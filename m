Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbXCXP7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbXCXP7B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:59:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXCXP7A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:59:00 -0400
Received: from linux6.nezu.wide.ad.jp ([203.178.142.218]:60738 "EHLO
	nezu.linux-ipv6.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbXCXP6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:58:37 -0400
Date: Sun, 25 Mar 2007 00:56:55 +0900 (JST)
Message-Id: <20070325.005655.719893000.takamiya@linux-ipv6.org>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, usagi-core@linux-ipv6.org
Subject: Re: (usagi-core 32633) [PATCH 1/2] [USB] [PL2303]: fixed to skip
 NULL entry in pl2303_shutdown.
From: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
In-Reply-To: <20070325.005417.189728335.takamiya@linux-ipv6.org>
References: <20070325.005227.432838064.takamiya@linux-ipv6.org>
	<20070325.005417.189728335.takamiya@linux-ipv6.org>
X-Face: +<)&j!Ce24nM@a.\f6TA,]^9Q76[_QN_[QR-(bT&>b40Oo[:`R(>b7!b-|q5k&.8CO[_Oh_
 !9Nk0rikK70~?|08EFH|:]iF6pwPlnfEn-wo-voY:rP?%7p%cxjnbf'hglO'se&QwZN7/RVX!U7*P%
 cTV('HfHp+?g1+hx7\+J.W]<O~hbwx[4hPPO=T<7aV2^7["&p^h4:YbY6,bS,ecZ7S5<pIUTnT''}k
 ={TEs)bN%-8Jdo~.Q_lpa-fN^.Fo9dFB*}\@=PK@0pmvZ3k0p-5hMQ<bjyK{enk/sOQ[<(k]}Q\p>G
 zYWv%LsDc
X-Mailer: Mew version 5.1 on XEmacs 21.4.17 (Jumbo Shrimp)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for resending.

  While booting, this entry is set to NULL in destroy_serial(),
  but serial->port is referred again in pl2303_shutdown() via
  serial->type->shutdown.

Signed-off-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

---
 drivers/usb/serial/pl2303.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 83dfae9..d631f8c 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -905,6 +905,8 @@ static void pl2303_shutdown(struct usb_s
 	dbg("%s", __FUNCTION__);
 
 	for (i = 0; i < serial->num_ports; ++i) {
+		if (!serial->port[i])
+			continue;
 		priv = usb_get_serial_port_data(serial->port[i]);
 		if (priv) {
 			pl2303_buf_free(priv->buf);
-- 
1.4.4

--
Noriaki TAKAMIYA


