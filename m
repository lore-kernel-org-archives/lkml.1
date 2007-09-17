Return-Path: <linux-kernel-owner+w=401wt.eu-S1757013AbXIQSgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013AbXIQSgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:36:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758078AbXIQSei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:34:38 -0400
Received: from smtp116.plus.mail.re1.yahoo.com ([69.147.102.79]:48785 "HELO
	smtp116.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757281AbXIQSeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:34:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=PXTmarjzbJntnbM2QSEdmbC1U9XuW/h3Htrn4ZIXGoP40PJGUDb4j4ZLQWLkWvrkohu5C3Z5sLCbPpC1MVaGNJekPkO9LuiQcOEixFTHWVrvsC7Z3jN4zPFnJIktqlVt+qfpGr2jl9ZtzSkDrOQbEMS7z6f7MPiR7fEUAbhw3BM=  ;
X-YMail-OSG: O1M1R5kVM1lKUsbmPfRH1tKFdgmr19WbSWlYtnq.nvH2S7qwb9cIHmBiZEeUyrpkhhVqZDWNIg--
Date: Mon, 17 Sep 2007 20:33:46 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions
Message-ID: <20070917183346.GA9006@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070917175139.GA4941@gollum.tnic> <46EEC418.6070005@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46EEC418.6070005@goop.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2007 at 11:14:48AM -0700, Jeremy Fitzhardinge wrote:
> Borislav Petkov wrote:
> > This patches remove redundant DMA_..BIT_MASK definitions across two drivers.
> > First off, consolidate dma bitmask definitions in the proper header file...
> >
> > Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> >
> > --
> > Index: 23-rc6/include/linux/dma-mapping.h
> > ===================================================================
> > --- 23-rc6/include/linux/dma-mapping.h.orig	2007-09-17 17:48:20.000000000 +0200
> > +++ 23-rc6/include/linux/dma-mapping.h	2007-09-17 19:34:21.000000000 +0200
> > @@ -17,6 +17,7 @@
> >  #define DMA_48BIT_MASK	0x0000ffffffffffffULL
> >  #define DMA_40BIT_MASK	0x000000ffffffffffULL
> >  #define DMA_39BIT_MASK	0x0000007fffffffffULL
> > +#define DMA_35BIT_MASK	0x00000007ffffffffULL
> >  #define DMA_32BIT_MASK	0x00000000ffffffffULL
> >  #define DMA_31BIT_MASK	0x000000007fffffffULL
> >  #define DMA_30BIT_MASK	0x000000003fffffffULL
> >   
> 
> Hm.  Wouldn't it be better to define something like
> 
> #define DMA_BIT_MASK(x)    ((1ull<<(x))-1)
> 
> and then define everything in terms of that (or just use it directly and
> deprecate the DMA_XXBIT_MASK macros)?
> 
>     J
That is more compact, I agree. However, the XXBIT_MASK macros have the
better readability, imho. And also, doing 

$grep -Prin 'DMA_..BIT_MASK' * | wc -l

returns 383 on the 23-rc6 tree so removing them should be quite the logistical
challenge for the kernel janitors :). What do the others think?

-- 
Regards/Gruﬂ,
    Boris.
