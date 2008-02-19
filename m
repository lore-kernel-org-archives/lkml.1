Return-Path: <linux-kernel-owner+w=401wt.eu-S1762203AbYBSWER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203AbYBSWER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754648AbYBSWD5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:03:57 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:1817 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbYBSWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:03:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=kFOP67WTqpEKLM/M9BNSJU6+km4aNbicxBbG/GbXuEMuepfbdFOQF5QFhdJwm1At+vc/7utpUh2WJPuNPJPLyWuiEjLPV8yT6/HaM5dMAynrvsi3zzmPiYVkJONZFMZg8Aj1m/XM29UB+jzKD6BugMWsN1k2vAa5Gb3U8JRZbf8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 4/5] ide-generic: use ide_find_port()
Date: Tue, 19 Feb 2008 22:20:08 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain> <20080217185133.16210.73293.sendpatchset@localhost.localdomain> <47BACC7C.6030305@ru.mvista.com>
In-Reply-To: <47BACC7C.6030305@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802192220.08554.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> > There should be no functional changes caused by this patch.
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> > Index: b/drivers/ide/ide-generic.c
> > ===================================================================
> > --- a/drivers/ide/ide-generic.c
> > +++ b/drivers/ide/ide-generic.c
> > @@ -90,18 +90,27 @@ static int __init ide_generic_init(void)
> >  	int i;
> >  
> >  	for (i = 0; i < MAX_HWIFS; i++) {
> > -		ide_hwif_t *hwif = &ide_hwifs[i];
> > +		ide_hwif_t *hwif;
> >  		unsigned long io_addr = ide_default_io_base(i);
> >  		hw_regs_t hw;
> >  
> > -		if (hwif->chipset == ide_unknown && io_addr) {
> > -			u8 oldnoprobe = hwif->noprobe;
> > +		if (io_addr) {
> > +			u8 oldnoprobe;
> > +
> > +			/*
> > +			 * Skip probing if the corresponding
> > +			 * slot entry is already occupied.
> 
>     IMHO, it's either "slot" or "entry", else it sounds superfluous. :-)

I made 'take 2' with "entry" removed, thanks.
