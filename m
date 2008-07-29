Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYG2Hwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYG2Hwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753014AbYG2Hwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:52:44 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:39554 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbYG2Hwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:52:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=IN1y+gW9wv7De3IrljyICLVzn3+rjrYTh5hlyhjjiUrijH1RcONjWWAbe4y3nho08e
         724InSkVQUw41cP27Rm+BqfSdv1YDSJfz1EnvAIw+azwL3ZOjDNIvmseckiQu6UP2Oo1
         R228Sh9tgiRuYEmBy9DZypwJNTtcIFT9pN9W0=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: "pHilipp Zabel" <philipp.zabel@gmail.com>
Subject: Re: [PATCH] fix misalignment in pxamci
Date: Tue, 29 Jul 2008 09:55:18 +0200
User-Agent: KMail/1.9.9
Cc: "Uli Luckas" <u.luckas@road.de>, LKML <linux-kernel@vger.kernel.org>,
       drzeus-mmc@drzeus.cx
References: <200807050219.52218.marek.vasut@gmail.com> <200807281823.25302.u.luckas@road.de> <74d0deb30807282330y142cedd2ld0ecf33cc459a75a@mail.gmail.com>
In-Reply-To: <74d0deb30807282330y142cedd2ld0ecf33cc459a75a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807290955.18889.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Tuesday 29 of July 2008 08:30:09 pHilipp Zabel napsal(a):
> On Mon, Jul 28, 2008 at 6:23 PM, Uli Luckas <u.luckas@road.de> wrote:
> > On Saturday, 5. July 2008, pHilipp Zabel wrote:
> >> On Sat, Jul 5, 2008 at 2:19 AM, Marek Vasut <marek.vasut@gmail.com> 
wrote:
> >> > Hi,
> >> > Philipp Zabel finally made the pxamci issue clear. It turned out, that
> >> > pxamci needs the DMA destination address to be aligned to 8 bytes. In
> >> > some cases it happened, that the address was aligned to 4 bytes
> >> > causing controller to incorrectly transfer data (and resulting into
> >> > error like "mmc0: unrecognised SCR structure version 1"). The
> >> > following patch allows to debug this issue and moreover fixes it by
> >> > moving one 4 byte entry of mmc_card structure, aligning the DMA
> >> > destination back to 8 bytes.
> >> >
> >> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> >>
> >> We can enable byte aligned transfers on the DMA controller. This is
> >> what I came up with yesterday:
> >> (sorry for wrapped lines - the proper patch should probably be a
> >> combination of both
> >> warning/DALGN handling and and moving something in mmc_card around).
> >
> > Hi Philipp,
> > this driver is not only for pxa27x but for pxa25x as well and pxa25x
> > can't handle unaligned DMA.
> > Shouldn't Marek Vasut's patch be included for the PXA25x case?
>
> Argh, DALGN shouldn't be defined in pxa-regs.h. We really need an
> aligned SCR target then. Pierre, is there any way we can have the MMC
> core align DMA targets for pxa25x?
>
> Just moving elements of the mmc_card structure around seems to be good
> enough, but I fear this will break again as soon as the next person
> forgets about pxamci's special needs on pxa25x.

Well cant we just add some comment to mmc_card .... like "your eyes will bulge 
with horror if you add something before this point"? ;-)
>
> regards
> Philipp


