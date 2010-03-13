Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934990Ab0CMAUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:20:43 -0500
Received: from kroah.org ([198.145.64.141]:60654 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934889Ab0CMAT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:19:58 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:08 2010
Message-Id: <20100313001508.397607491@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Robert Richter <robert.richter@amd.com>
Subject: [patch 037/123] oprofile/x86: remove node check in AMD IBS initialization
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Robert Richter <robert.richter@amd.com>

commit 89baaaa98a10cad5cc8516c7208b02d9fc711890 upstream.

Standard AMD systems have the same number of nodes as there are
northbridge devices. However, there may kernel configurations
(especially for 32 bit) or system setups exist, where the node number
is different or it can not be detected properly. Thus the check is not
reliable and may fail though IBS setup was fine. For this reason it is
better to remove the check.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/op_model_amd.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -386,16 +386,6 @@ static int init_ibs_nmi(void)
 		return 1;
 	}
 
-#ifdef CONFIG_NUMA
-	/* Sanity check */
-	/* Works only for 64bit with proper numa implementation. */
-	if (nodes != num_possible_nodes()) {
-		printk(KERN_DEBUG "Failed to setup CPU node(s) for IBS, "
-			"found: %d, expected %d",
-			nodes, num_possible_nodes());
-		return 1;
-	}
-#endif
 	return 0;
 }
 


