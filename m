Return-Path: <linux-kernel-owner+w=401wt.eu-S1751801AbZKZS2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801AbZKZS2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 13:28:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbZKZS2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 13:28:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59798 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZKZS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 13:28:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=sBGDuUnabPhe+ZyJnagNyjGdHZww2C/0oHyxk/xoKHG0Vb6ymu4w32hIDB5d/R0wFb
         dFlN0H3869Tvz6wGbwsNSHBZH006RLb/+pyfhAgwp3gpwXfX3ajOg9DcOLpr0+cXYe+S
         HkmVN8Bf/YEIJulHKLYpUqxXSqLMVGjaeIV6Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] pata_it8213: MWDMA0 is unsupported
Date: Thu, 26 Nov 2009 19:27:00 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200911261728.36433.bzolnier@gmail.com> <200911261903.01199.bzolnier@gmail.com> <4B0EC52B.2070805@ru.mvista.com>
In-Reply-To: <4B0EC52B.2070805@ru.mvista.com>
MIME-Version: 1.0
Message-Id: <200911261927.00597.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 07:12:59 pm Sergei Shtylyov wrote:
> Bartlomiej Zolnierkiewicz wrote:
> 
> >>>>>MWDMA0 timings cannot be met with the PIIX based controller
> >>>>>programming interface.
> >>>
> >>>>>This change should be safe as this is how we have been doing
> >>>>>things in IDE it8213 host driver for years.
> >>>
> >>>>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>>>>---
> >>>>>Verified with the documentation (similar case as with pata_efar).
> 
> >>>>Uhhh, no...
> 
> >>>>Too many damn drivers.
> 
> >>>>Too much damn duplication.
> 
> >>>>Too much damn subtle differences here and there.
> 
> >>>>The hardware is probably fine for MWMDA0 when it comes to pata_{efar,it8213},
> >>>>it just not documented properly in the data sheet.
> 
> >>>    How so with pata_efar? The active/recovery bitfields are still 2-bit 
> >>>wide, no?
> 
> >>Yes but when TIMEx bit is disabled we are using XFER_PIO_SLOW timings.
> 
>     600 ns cycle vs spec'ed 480 ns? Is it really worth it?

960 ns actually

> >>All data sheets including original Intel ones are a complete crap when it
> >>comes to explicitly documenting this behavior.
> 
> > OTOH all drivers set TIMEx for MWDMA0 currently.. ?
> 
>     ... which would give a grossly overclocked timing.

Except ata_piix which blacklists MWDMA0 for _all_ PATA controllers.. :)

I'm leaving my patches as they were for now, unless somebody wants to
untangle this mess this is a safest and quickest way forward..

--
Bartlomiej Zolnierkiewicz
