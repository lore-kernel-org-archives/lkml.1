Return-Path: <linux-kernel-owner+w=401wt.eu-S1752943AbXCXP56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbXCXP56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 11:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXCXP56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 11:57:58 -0400
Received: from linux6.nezu.wide.ad.jp ([203.178.142.218]:60703 "EHLO
	nezu.linux-ipv6.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbXCXP55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 11:57:57 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Mar 2007 11:57:57 EDT
Date: Sun, 25 Mar 2007 00:57:53 +0900 (JST)
Message-Id: <20070325.005753.497716904.takamiya@linux-ipv6.org>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, usagi-core@linux-ipv6.org
Subject: Re: (usagi-core 32634) [PATCH 2/2] [USB] [SERIAL]: fixed to skip
 NULL port entry in struct usb_serial_port.
From: Noriaki TAKAMIYA <takamiya@linux-ipv6.org>
In-Reply-To: <20070325.005507.424245753.takamiya@linux-ipv6.org>
References: <20070325.005227.432838064.takamiya@linux-ipv6.org>
	<20070325.005507.424245753.takamiya@linux-ipv6.org>
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

Hi,

  This patch fixes to skip serial->port[i] if it is set NULL.

Signed-off-by: Noriaki TAKAMIYA <takamiya@po.ntts.co.jp>

---
 include/linux/usb/serial.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
index 32acbae..85ed5ef 100644
--- a/include/linux/usb/serial.h
+++ b/include/linux/usb/serial.h
@@ -99,7 +99,10 @@ struct usb_serial_port {
 /* get and set the port private data pointer helper functions */
 static inline void *usb_get_serial_port_data (struct usb_serial_port *port)
 {
-	return dev_get_drvdata(&port->dev);
+	if (port)
+		return dev_get_drvdata(&port->dev);
+	else
+		return NULL;
 }
 
 static inline void usb_set_serial_port_data (struct usb_serial_port *port, void *data)
-- 
1.4.4

--
Noriaki TAKAMIYA
