Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109Ab0ARSXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0ARSXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487Ab0ARSXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:23:35 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:40385 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0ARSXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:23:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=sgoriPObpn+Xx8BtvZStM3Zm1taWILgewRi4Kzkuj97EurYtEuBqU5JOY7rO8/J0X1
         qEbCc8sp7JQV1D2k8G9Tn8TZVU9PtzpVhWUoXtb66iu72yRCFsX/fhFi3VoVahygpyd2
         dYwv3bdU37mZv8Th94CGVhEeOoJQfQVEoMtco=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 03/64] pata_ali: cleanup ali_set_piomode()
Date: Mon, 18 Jan 2010 19:16:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171412.14623.94854.sendpatchset@localhost> <20100118174602.47f8ec24@lxorguk.ukuu.org.uk>
In-Reply-To: <20100118174602.47f8ec24@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Message-Id: <201001181916.15161.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010 06:46:02 pm Alan Cox wrote:
> On Mon, 18 Jan 2010 18:14:12 +0100
> Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] pata_ali: cleanup ali_set_piomode()
> > 
> > Merge ali_fifo_control() calls.
> 
> This also changes the behaviour. The old driver, reference code and old
> IDE driver (at least at the time I did pata_ali) all did the fifo off
> case, then the mode change, then the FIFO on case.

Well, the old IDE driver (both at the time you did pata_ali and currently)
did it the way this patch does and unfortunately I'm not familiar with
the reference code (I worry that it may be available under NDA only)..

> I don't see why it should matter but it ought to be noted in the changelog

Indeed, though this should be quite obvious from looking at the patch
(below for reference) and the lack of my usual "no functionality changes"
note..

---
 drivers/ata/pata_ali.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: b/drivers/ata/pata_ali.c
===================================================================
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -222,12 +222,9 @@ static void ali_set_piomode(struct ata_p
 	}
 
 	/* PIO FIFO is only permitted on ATA disk */
-	if (adev->class != ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x00);
-	ali_program_modes(ap, adev, &t, 0);
-	if (adev->class == ATA_DEV_ATA)
-		ali_fifo_control(ap, adev, 0x05);
+	ali_fifo_control(ap, adev, (adev->class == ATA_DEV_ATA) ? 0x05 : 0x00);
 
+	ali_program_modes(ap, adev, &t, 0);
 }
 
 /**
