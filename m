Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZKBP0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZKBP0j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 10:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755307AbZKBP0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 10:26:38 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:16431 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297AbZKBP0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 10:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=mNHvE725uCBcR2ZsLAjGU5J/MpwA+Cid2SjSlH76ytyzFqQmFIviXAUyP2L+ZXFLSy
         aRNgLmijalhgWwGyCNg+6rS2HFcROhENP/17PoNpZ+rn6sfytDSBWDNpjFeKqZNPfWaK
         Rk+0KpOMKRalBwmfKYeIsthwRCCJmqx8nJ6hs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: [PATCH] Staging: rt28x0: Add proper selection of WIRELESS_EXT and WEXT_PRIV
Date: Mon, 2 Nov 2009 16:25:32 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911021625.32165.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the incorporation of the patch entitled "wext: refactor", some
of the wireless drivers in drivers/staging fail to build because they
need to have CONFIG_WIRELESS_EXT and CONFIG_WEXT_PRIV defined.

[ patch description borrowed from the previous fix for wireless staging
  drivers ("staging: Add proper selection of WIRELESS_EXT and WEXT_PRIV")
  authored by Larry Finger ]

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/Kconfig |    2 ++
 drivers/staging/rt2870/Kconfig |    2 ++
 2 files changed, 4 insertions(+)

Index: b/drivers/staging/rt2860/Kconfig
===================================================================
--- a/drivers/staging/rt2860/Kconfig
+++ b/drivers/staging/rt2860/Kconfig
@@ -1,6 +1,8 @@
 config RT2860
 	tristate "Ralink 2860/3090 wireless support"
 	depends on PCI && X86 && WLAN
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	---help---
 	  This is an experimental driver for the Ralink 2860 and 3090
 	  wireless chips.
Index: b/drivers/staging/rt2870/Kconfig
===================================================================
--- a/drivers/staging/rt2870/Kconfig
+++ b/drivers/staging/rt2870/Kconfig
@@ -1,5 +1,7 @@
 config RT2870
 	tristate "Ralink 2870/3070 wireless support"
 	depends on USB && X86 && WLAN
+	select WIRELESS_EXT
+	select WEXT_PRIV
 	---help---
 	  This is an experimental driver for the Ralink xx70 wireless chips.
