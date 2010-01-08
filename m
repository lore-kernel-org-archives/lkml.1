Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548Ab0AHOki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab0AHOki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 09:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488Ab0AHOkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 09:40:37 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:59132 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab0AHOkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 09:40:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=abugSGKaE0QZrOzkXDo50pxlCHmwThCftALaETKWJo/nYrAfKCTuNfCev+oPC9Mmtq
         h/VfIZFTOKVSk58oCU+5j76sogZXHHb/x9YDUxZSHbkCzwoSQUfpGGj1cPpeN+0oCSCJ
         VC9ov8FnDq41Hwk7ZXQOClZTljllXinMxDI+o=
Subject: [PATCH] : hardware/mISDN/mISDNinfineon.c: Bail out of loop on error
From: Darren Jenkins <darrenrjenkins@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>, keil@isdn4linux.de
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Jan 2010 01:40:34 +1100
Message-ID: <1262961634.32453.12.camel@ICE-BOX>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If setup_instance() fails we kfree() the card, and then use it in the next loop iteration.
So lets bail out of the loop instead.

Coverity CID: 13357

Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com> 

diff --git drivers/isdn/hardware/mISDN/mISDNinfineon.c drivers/isdn/hardware/mISDN/mISDNinfineon.c
index 62441ba..36c6c61 100644
--- drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -1133,6 +1133,7 @@ inf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			if (err) {
 				kfree(sc);
 				release_card(card);
+				break;
 			} else
 				card->sc[i - 1] = sc;
 		}


