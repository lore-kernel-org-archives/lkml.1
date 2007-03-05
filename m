Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbXCEWCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbXCEWCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbXCEWCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:02:22 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:2900 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbXCEWB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:01:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=USXwpmO6ipjTzmnefndK+jRVc7xs+6NTm5OCqa+5380JvHKfHGdo3U5ykBi2s3X2IuTzR/WsHNbcnEsVOm/OcAwsHH1oHdknVV7k0yIUonNn+IXLsluph6Gn0t3ufI9R1KVjWex9GqBBtNfp3wWXPr9giG3ks+FKcSxR1WSJk40=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH][pata-2.6 tree] pdc202xx_old: rewrite mode programming code
Date: Mon, 5 Mar 2007 23:08:36 +0100
User-Agent: KMail/1.9.6
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200703040149.46186.bzolnier@gmail.com> <45EC82BB.8000709@ru.mvista.com> <45EC8713.5060304@ru.mvista.com>
In-Reply-To: <45EC8713.5060304@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703052308.36887.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 05 March 2007, Sergei Shtylyov wrote:
> Hello, I wrote:
> 
> >> official == same as in the docs and vendor driver :-)
> 
> >>>    Erm, those look a bit doubtful...
> 
> >> I believe that they are correct - please see explanations below.
> 
> >    Yeah, sorry about that. Only SWDMA timings are suspicious.
> 
>     Hm, too early to say sorry. I was hasty/distacted and forgot what I was 
> going to write... :-)
> 
> >>>> Index: b/drivers/ide/pci/pdc202xx_old.c
> >>>> ===================================================================
> >>>> --- a/drivers/ide/pci/pdc202xx_old.c
> >>>> +++ b/drivers/ide/pci/pdc202xx_old.c
> >>>
> >>> [...]
> 
> >>>> @@ -161,7 +95,7 @@ static int pdc202xx_tune_chipset (ide_dr
> >>>>         case XFER_UDMA_0:
> >>>>         case XFER_MW_DMA_2:    TB = 0x60; TC = 0x03; break;
> >>>>         case XFER_MW_DMA_1:    TB = 0x60; TC = 0x04; break;
> >>>> -        case XFER_MW_DMA_0:
> >>>> +        case XFER_MW_DMA_0:    TB = 0xE0; TC = 0x0F; break;
> 
> >>>    This seems even slower than SWDMA0!
> >>>    Let's assume that means 7 active cycles and 15 recovery cycles 
> >>> (MWDMA1/2 settings seem to confirm this hypothesis) -- this would 
> >>> give us 720 ns vs the specified 480. Could you shed some light on 
> >>> what these fields mean? :-/
> 
> >> The calculations are done in a different way so we get the correct 
> >> timings:
> 
> >>  7 cycles (== 210 ns) are used for active time
> 
>     Ugh, forgot to say: this is overclocked, 215 ns is the minimum active time 
> for this mode.

I know that is why I wrote in my previous mail:

"These timings are the maximum possible ones using MB[2:0] and MC[3:0]"

Driver can't do better than hardware and hopefully these 5 ns
are compensated somehow by the chipset (or not :-).

Bart
