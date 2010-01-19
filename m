Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075Ab0ASPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0ASPL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 10:11:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130Ab0ASPLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 10:11:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:48848 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab0ASPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 10:11:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=rSjRsHTXoqSaL0SfGuu73IlA4vT9oT7dV/bSFhJsbbdKR3yhvARBZml6GjkntvfddM
         i5YKttiUO1gsN3MDy7pFFds0OWCDrNCMeSnZuTwYSZwayEDjMpaxuM3EiM/sy+PDpIFX
         za38ZLA/H8ZHuCIboEVwakpv1MZ7qxV+Lsd2I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 25/64] ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
Date: Tue, 19 Jan 2010 16:09:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171729.14623.46024.sendpatchset@localhost> <20100119.012526.203639880.davem@davemloft.net>
In-Reply-To: <20100119.012526.203639880.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <201001191609.42582.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 January 2010 10:25:26 am David Miller wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Mon, 18 Jan 2010 18:17:29 +0100
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] ide: use standard timing for XFER_PIO_SLOW mode in ide_timing_compute()
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Applied.

Thanks.

Here is a bonus fixup for a small issue noticed by Sergei yesterday.

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: ide_timing_compute() fixup

XFER_SW_DMA_0 mode should be excluded from the extended cycle
timing computations.

[ This is just a documentation fix -- code inside the affected
  'if' block already makes sure to accept only PIO modes. ]

Noticed-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-timings.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/ide/ide-timings.c
===================================================================
--- a/drivers/ide/ide-timings.c
+++ b/drivers/ide/ide-timings.c
@@ -166,7 +166,7 @@ int ide_timing_compute(ide_drive_t *driv
 	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
 		memset(&p, 0, sizeof(p));
 
-		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
+		if (speed >= XFER_PIO_0 && speed < XFER_SW_DMA_0) {
 			if (speed <= XFER_PIO_2)
 				p.cycle = p.cyc8b = id[ATA_ID_EIDE_PIO];
 			else if ((speed <= XFER_PIO_4) ||
