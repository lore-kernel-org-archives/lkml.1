Return-Path: <linux-kernel-owner+w=401wt.eu-S1753683Ab0AIUxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0AIUxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 15:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753162Ab0AIUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 15:53:43 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:36686 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab0AIUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 15:53:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=RxS+5B3KgpqhCMNrnbdCPk8KG/zzRyYAhXqksAaJXJS4sCxFhT1yxusD6RBAvC4mzD
         d9ELHZiCHdFaKAv5XZJ0F+aukJ1O/iWXQCyLmUGzWM6DDva64L6rKVOcbAYGYbcfnhvE
         Jej/AgDgPxeJ5aB5glAfmv1+RsrO0u6ZyeAeY=
Message-ID: <4B48EDC8.1000006@gmail.com>
Date: Sat, 09 Jan 2010 21:57:44 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Felipe Balbi <felipe.balbi@nokia.com>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] musb: don't dereference NULL tusb_dma in dma_controller_destroy()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test whether tusb_dma is not NULL before dereferencing

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/usb/musb/tusb6010_omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/musb/tusb6010_omap.c b/drivers/usb/musb/tusb6010_omap.c
index e13c770..1c86809 100644
--- a/drivers/usb/musb/tusb6010_omap.c
+++ b/drivers/usb/musb/tusb6010_omap.c
@@ -648,7 +648,7 @@ void dma_controller_destroy(struct dma_controller *c)
 		}
 	}
 
-	if (!tusb_dma->multichannel && tusb_dma && tusb_dma->ch >= 0)
+	if (tusb_dma && !tusb_dma->multichannel && tusb_dma->ch >= 0)
 		omap_free_dma(tusb_dma->ch);
 
 	kfree(tusb_dma);
