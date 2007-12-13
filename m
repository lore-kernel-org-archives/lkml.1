Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbXLMHHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbXLMHHu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759713AbXLMG46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:58 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55321 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760763AbXLMG44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:56 -0500
Date: Wed, 12 Dec 2007 22:52:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Karsten Keil <kkeil@suse.de>
Subject: [patch 28/60] isdn: avoid copying overly-long strings
Message-ID: <20071213065221.GC6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="isdn-avoid-copying-overly-long-strings.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Karsten Keil <kkeil@suse.de>

patch 0f13864e5b24d9cbe18d125d41bfa4b726a82e40 in mainline.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=9416

Signed-off-by: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/isdn/i4l/isdn_net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/isdn/i4l/isdn_net.c
+++ b/drivers/isdn/i4l/isdn_net.c
@@ -2126,7 +2126,7 @@ isdn_net_find_icall(int di, int ch, int 
 	u_long flags;
 	isdn_net_dev *p;
 	isdn_net_phone *n;
-	char nr[32];
+	char nr[ISDN_MSNLEN];
 	char *my_eaz;
 
 	/* Search name in netdev-chain */
@@ -2135,7 +2135,7 @@ isdn_net_find_icall(int di, int ch, int 
 		nr[1] = '\0';
 		printk(KERN_INFO "isdn_net: Incoming call without OAD, assuming '0'\n");
 	} else
-		strcpy(nr, setup->phone);
+		strlcpy(nr, setup->phone, ISDN_MSNLEN);
 	si1 = (int) setup->si1;
 	si2 = (int) setup->si2;
 	if (!setup->eazmsn[0]) {
@@ -2802,7 +2802,7 @@ isdn_net_setcfg(isdn_net_ioctl_cfg * cfg
 				chidx = -1;
 			}
 		}
-		strcpy(lp->msn, cfg->eaz);
+		strlcpy(lp->msn, cfg->eaz, sizeof(lp->msn));
 		lp->pre_device = drvidx;
 		lp->pre_channel = chidx;
 		lp->onhtime = cfg->onhtime;
@@ -2951,7 +2951,7 @@ isdn_net_addphone(isdn_net_ioctl_phone *
 	if (p) {
 		if (!(n = kmalloc(sizeof(isdn_net_phone), GFP_KERNEL)))
 			return -ENOMEM;
-		strcpy(n->num, phone->phone);
+		strlcpy(n->num, phone->phone, sizeof(n->num));
 		n->next = p->local->phone[phone->outgoing & 1];
 		p->local->phone[phone->outgoing & 1] = n;
 		return 0;

-- 
