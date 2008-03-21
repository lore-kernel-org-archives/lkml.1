Return-Path: <linux-kernel-owner+w=401wt.eu-S1758347AbYCUXp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758347AbYCUXp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbYCUXpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 19:45:31 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:60157 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbYCUXpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 19:45:22 -0400
Message-Id: <20080321224339.730625340@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:03 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       David S Miller <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 13/76] IPCONFIG: The kernel gets no IP from some DHCP servers
Content-Disposition: inline; filename=ipconfig-the-kernel-gets-no-ip-from-some-dhcp-servers.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Stephen Hemminger <shemminger@linux-foundation.org>

Upstream commit: dea75bdfa57f75a7a7ec2961ec28db506c18e5db

From: Stephen Hemminger <shemminger@linux-foundation.org>

Based upon a patch by Marcel Wappler:

   This patch fixes a DHCP issue of the kernel: some DHCP servers
   (i.e.  in the Linksys WRT54Gv5) are very strict about the contents
   of the DHCPDISCOVER packet they receive from clients.

   Table 5 in RFC2131 page 36 requests the fields 'ciaddr' and
   'siaddr' MUST be set to '0'.  These DHCP servers ignore Linux
   kernel's DHCP discovery packets with these two fields set to
   '255.255.255.255' (in contrast to popular DHCP clients, such as
   'dhclient' or 'udhcpc').  This leads to a not booting system.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 net/ipv4/ipconfig.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -739,9 +739,9 @@ static void __init ic_bootp_send_if(stru
 		printk("Unknown ARP type 0x%04x for device %s\n", dev->type, dev->name);
 		b->htype = dev->type; /* can cause undefined behavior */
 	}
+
+	/* server_ip and your_ip address are both already zero per RFC2131 */
 	b->hlen = dev->addr_len;
-	b->your_ip = NONE;
-	b->server_ip = NONE;
 	memcpy(b->hw_addr, dev->dev_addr, dev->addr_len);
 	b->secs = htons(jiffies_diff / HZ);
 	b->xid = d->xid;

-- 
