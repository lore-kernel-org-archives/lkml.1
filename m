Return-Path: <linux-kernel-owner+w=401wt.eu-S1762939AbZD2WkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762939AbZD2WkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 18:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbZD2WVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 18:21:53 -0400
Received: from kroah.org ([198.145.64.141]:40710 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760094AbZD2WVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 18:21:48 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Apr 29 15:09:30 2009
Message-Id: <20090429220930.126527883@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 29 Apr 2009 15:07:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: [patch 48/58] ath9k: AR9280 PCI devices must serialize IO as well
References: <20090429220659.339950874@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-ar9280-pci-devices-must-serialize-io-as-well.patch
In-Reply-To: <20090429221657.GA11765@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

This is a port of:
commit SHA1 5ec905a8df3fa877566ba98298433fbfb3d688cc
for 2.6.27

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath9k/hw.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3313,7 +3313,8 @@ static struct ath_hal *ath9k_hw_do_attac
 	}
 
 	if (ah->ah_config.serialize_regmode == SER_REG_MODE_AUTO) {
-		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) {
+		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCI ||
+		    (AR_SREV_9280(ah) && !ah->ah_isPciExpress)) {
 			ah->ah_config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {


