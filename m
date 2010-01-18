Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446Ab0ARSas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0ARSas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 13:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755205Ab0ARSar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 13:30:47 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:29583 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab0ARSaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 13:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Dd57wPpWDCeRwNzxfweDJ7eqFJS6JMIGTTmdr21RkOdEVV5NVa49zG9lcgGNY5Eaz2
         Fu087S9OnCCjL28tMQF5w+JfkeohcrnJOy1ShW4/LHAqmGIXCRJkaZ+j+Od8I5hZc3Ia
         skADfmBgu/V70UqCL70FEyh9dcn3LjrUMMpTY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 01/64] libata: fix CFA handling in ide_timing_compute()
Date: Mon, 18 Jan 2010 19:29:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171357.14623.36435.sendpatchset@localhost> <4B54A724.6080701@ru.mvista.com>
In-Reply-To: <4B54A724.6080701@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <201001181929.17136.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010 07:23:32 pm Sergei Shtylyov wrote:
> Hello.

Hi!

> Bartlomiej Zolnierkiewicz wrote:
> 
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Subject: [PATCH] libata: fix CFA handling in ide_timing_compute()
> >
> > Use standard cycle timing for CFA PIO5 and PIO6 modes.
> >
> > Based on commit 74638c8 for IDE subsystem.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > ---
> >  drivers/ata/libata-core.c |   17 +++++++++++------
> >  1 file changed, 11 insertions(+), 6 deletions(-)
> >
> > Index: b/drivers/ata/libata-core.c
> > ===================================================================
> > --- a/drivers/ata/libata-core.c
> > +++ b/drivers/ata/libata-core.c
> > @@ -3211,6 +3211,7 @@ const struct ata_timing *ata_timing_find
> >  int ata_timing_compute(struct ata_device *adev, unsigned short speed,
> >  		       struct ata_timing *t, int T, int UT)
> >  {
> > +	const u16 *id = adev->id;
> >  	const struct ata_timing *s;
> >  	struct ata_timing p;
> >  
> > @@ -3228,14 +3229,18 @@ int ata_timing_compute(struct ata_device
> >  	 * PIO/MW_DMA cycle timing.
> >  	 */
> >  
> > -	if (adev->id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
> > +	if (id[ATA_ID_FIELD_VALID] & 2) {	/* EIDE drive */
> >  		memset(&p, 0, sizeof(p));
> > +
> >  		if (speed >= XFER_PIO_0 && speed <= XFER_SW_DMA_0) {
> >   
> 
>    BTW, shouldn't this actually be 'speed < XFER_SW_DMA_0'?

Good catch, I'll fix the patch later (would you be willing to fix
ide-timings.c side of things?).

--
Bartlomiej Zolnierkiewicz
