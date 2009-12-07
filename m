Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbZLGAWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbZLGAWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:22:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbZLGAV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:21:59 -0500
Received: from kroah.org ([198.145.64.141]:34638 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758570AbZLGANk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:13:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:55 2009
Message-Id: <20091207000655.644896526@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Ford <david@blue-labs.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: [084/119] ipv4: additional update of dev_net(dev) to struct *net in ip_fragment.c, NULL ptr OOPS
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=ipv4-additional-update-of-dev_net-dev-to-struct-net-in-ip_fragment.c-null-ptr-oops.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David Ford <david@blue-labs.org>

commit bbf31bf18d34caa87dd01f08bf713635593697f2 upstream.

ipv4 ip_frag_reasm(), fully replace 'dev_net(dev)' with 'net', defined
previously patched into 2.6.29.

Between 2.6.28.10 and 2.6.29, net/ipv4/ip_fragment.c was patched,
changing from dev_net(dev) to container_of(...).  Unfortunately the goto
section (out_fail) on oversized packets inside ip_frag_reasm() didn't
get touched up as well.  Oversized IP packets cause a NULL pointer
dereference and immediate hang.

I discovered this running openvasd and my previous email on this is
titled:  NULL pointer dereference at 2.6.32-rc8:net/ipv4/ip_fragment.c:566

Signed-off-by: David Ford <david@blue-labs.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/ipv4/ip_fragment.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -563,7 +563,7 @@ out_oversize:
 		printk(KERN_INFO "Oversized IP packet from %pI4.\n",
 			&qp->saddr);
 out_fail:
-	IP_INC_STATS_BH(dev_net(dev), IPSTATS_MIB_REASMFAILS);
+	IP_INC_STATS_BH(net, IPSTATS_MIB_REASMFAILS);
 	return err;
 }
 


