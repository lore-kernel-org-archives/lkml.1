Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZKDRck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZKDRck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbZKDRcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:32:39 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:41096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295AbZKDRcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:32:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=vcDDiGuNveLgUU754Q8/toVVCH/N06UdYRmUFW8oHpgFtvKd00EUK8qDYbZ4uuo2+0
         vy9inAeMr5lLIVsyJ2j0K+nHui8YmmyTsxpbbrcgCsyiknZ6xbWFSoh+nAF/xzIKuKPK
         Viob2GnmFMcMZwXF3z+h1l2oZQGtv51X3iH/o=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Gertjan van Wingerde <gwingerde@gmail.com>,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 04 Nov 2009 18:32:17 +0100
Message-Id: <20091104173217.28463.23610.sendpatchset@localhost.localdomain>
In-Reply-To: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
References: <20091104173151.28463.68742.sendpatchset@localhost.localdomain>
Subject: [PATCH 03/41] rt2800usb: fix rt2800usb_rfcsr_read()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] rt2800usb: fix rt2800usb_rfcsr_read()

The driver should write the read request into RF_CSR_CFG register
and not BBP_CSR_CFG one in rt2800usb_rfcsr_read().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/net/wireless/rt2x00/rt2800usb.c
===================================================================
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -167,7 +167,7 @@ static void rt2800usb_rfcsr_read(struct 
 		rt2x00_set_field32(&reg, RF_CSR_CFG_WRITE, 0);
 		rt2x00_set_field32(&reg, RF_CSR_CFG_BUSY, 1);
 
-		rt2x00usb_register_write_lock(rt2x00dev, BBP_CSR_CFG, reg);
+		rt2x00usb_register_write_lock(rt2x00dev, RF_CSR_CFG, reg);
 
 		WAIT_FOR_RFCSR(rt2x00dev, &reg);
 	}
