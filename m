Return-Path: <linux-kernel-owner+w=401wt.eu-S1755518Ab0ASUly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0ASUly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 15:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489Ab0ASUly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 15:41:54 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53502 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab0ASUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 15:41:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=xIQuLsHM7M6a6bB4QEtgrciAZ1DTxccG2J4G11hCkmYHgpvkp93ckAc1PvQsSFAkcx
         tS/0Y9nUHR5iWWS6kMfRx6gMEoB4oKuUr6OepqiagIlMZpAwx33jQy/RaVBNHvyvksW5
         MJ0OdoSA0VszJxa4JYMEMuDznz4K72bzK7Rc0=
Message-ID: <4B561A38.2060805@gmail.com>
Date: Tue, 19 Jan 2010 21:46:48 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] Comedi: G1-3 status registers not read in ni_gpct_to_660x_register()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read from the right status register

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
I think this was intended?

diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 404d3c5..1e20414 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -691,13 +691,13 @@ static enum NI_660x_Register ni_gpct_to_660x_register(enum ni_gpct_register reg)
 		ni_660x_register = G0StatusRegister;
 		break;
 	case NITIO_G1_Status_Reg:
-		ni_660x_register = G0StatusRegister;
+		ni_660x_register = G1StatusRegister;
 		break;
 	case NITIO_G2_Status_Reg:
-		ni_660x_register = G0StatusRegister;
+		ni_660x_register = G2StatusRegister;
 		break;
 	case NITIO_G3_Status_Reg:
-		ni_660x_register = G0StatusRegister;
+		ni_660x_register = G3StatusRegister;
 		break;
 	case NITIO_G0_Interrupt_Enable_Reg:
 		ni_660x_register = G0InterruptEnable;
