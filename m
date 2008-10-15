Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbYJOVdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbYJOVdd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbYJOVdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:33:19 -0400
Received: from www.steve.org.uk ([80.68.85.46]:39284 "EHLO skx.xen-hosting.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbYJOVdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:33:18 -0400
Date: Wed, 15 Oct 2008 22:33:16 +0100
From: Steve Kemp <steve@steve.org.uk>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] compiler warning cleanup
Message-ID: <20081015213316.GA9322@steve.org.uk>
References: <20081015180732.GA4119@steve.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081015180732.GA4119@steve.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch corrects the following gcc warning in several places:

   warning: control reaches end of non-void function

It does this by adding harmless "return 0", or "return NULL", after
the use of BUG().

My first kernel submission, be gentle with me ;)

Signed-off-by: Steve Kemp <steve@steve.org.uk>

---


diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/arch/x86/kernel/genx2apic_uv_x.c linux-2.6.27/arch/x86/kernel/genx2apic_uv_x.c
--- linux-2.6.27.orig/arch/x86/kernel/genx2apic_uv_x.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/arch/x86/kernel/genx2apic_uv_x.c	2008-10-15 22:25:23.000000000 +0100
@@ -181,6 +181,7 @@ static __init int boot_pnode_to_blade(in
 		if (pnode == uv_blade_info[blade].pnode)
 			return blade;
 	BUG();
+        return 0;
 }

 struct redir_addr {
diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/block/cfq-iosched.c linux-2.6.27/block/cfq-iosched.c
--- linux-2.6.27.orig/block/cfq-iosched.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/block/cfq-iosched.c	2008-10-15 22:25:39.000000000 +0100
@@ -1497,6 +1497,7 @@ cfq_async_queue_prio(struct cfq_data *cf
 		return &cfqd->async_idle_cfqq;
 	default:
 		BUG();
+                return NULL;
 	}
 }

diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/drivers/hwmon/adt7473.c linux-2.6.27/drivers/hwmon/adt7473.c
--- linux-2.6.27.orig/drivers/hwmon/adt7473.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/drivers/hwmon/adt7473.c	2008-10-15 22:25:54.000000000 +0100
@@ -805,6 +805,7 @@ static ssize_t show_pwm_auto_temp(struct
 	}
 	/* shouldn't ever get here */
 	BUG();
+        return NULL;
 }

 static ssize_t set_pwm_auto_temp(struct device *dev,
diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/drivers/hwmon/i5k_amb.c linux-2.6.27/drivers/hwmon/i5k_amb.c
--- linux-2.6.27.orig/drivers/hwmon/i5k_amb.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/drivers/hwmon/i5k_amb.c	2008-10-15 22:26:07.000000000 +0100
@@ -481,6 +481,7 @@ static unsigned long i5k_channel_pci_id(
 		return PCI_DEVICE_ID_INTEL_5400_FBD0 + channel;
 	default:
 		BUG();
+                return 0;
 	}
 }

diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/drivers/memstick/core/mspro_block.c linux-2.6.27/drivers/memstick/core/mspro_block.c
--- linux-2.6.27.orig/drivers/memstick/core/mspro_block.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/drivers/memstick/core/mspro_block.c	2008-10-15 22:26:25.000000000 +0100
@@ -653,6 +653,7 @@ has_int_reg:

 	default:
 		BUG();
+                return 0;
 	}
 }

diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/fs/dcache.c linux-2.6.27/fs/dcache.c
--- linux-2.6.27.orig/fs/dcache.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/fs/dcache.c	2008-10-15 22:26:42.000000000 +0100
@@ -1874,6 +1874,7 @@ out_nolock:
 shouldnt_be_hashed:
 	spin_unlock(&dcache_lock);
 	BUG();
+        return NULL;
 }

 static int prepend(char **buffer, int *buflen, const char *str, int namelen)
diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/mm/bootmem.c linux-2.6.27/mm/bootmem.c
--- linux-2.6.27.orig/mm/bootmem.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/mm/bootmem.c	2008-10-15 22:26:57.000000000 +0100
@@ -318,6 +318,7 @@ static int __init mark_bootmem(unsigned
 		pos = bdata->node_low_pfn;
 	}
 	BUG();
+        return 0;
 }

 /**
diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/mm/mempolicy.c linux-2.6.27/mm/mempolicy.c
--- linux-2.6.27.orig/mm/mempolicy.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/mm/mempolicy.c	2008-10-15 22:27:13.000000000 +0100
@@ -1410,6 +1410,7 @@ unsigned slab_node(struct mempolicy *pol

 	default:
 		BUG();
+                return 0;
 	}
 }

diff --ignore-space-change -uprN -X linux-2.6.27.orig/Documentation/dontdiff linux-2.6.27.orig/net/rfkill/rfkill.c linux-2.6.27/net/rfkill/rfkill.c
--- linux-2.6.27.orig/net/rfkill/rfkill.c	2008-10-09 23:13:53.000000000 +0100
+++ linux-2.6.27/net/rfkill/rfkill.c	2008-10-15 22:27:28.000000000 +0100
@@ -325,6 +325,7 @@ static const char *rfkill_get_type_str(e
 		return "wwan";
 	default:
 		BUG();
+                return NULL;
 	}
 }




Steve
-- 
Managed Anti-Spam Service
http://mail-scanning.com/

