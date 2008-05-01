Return-Path: <linux-kernel-owner+w=401wt.eu-S933380AbYEAWwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933380AbYEAWwd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 18:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932954AbYEAWwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 18:52:05 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:14281 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081AbYEAWwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 18:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=d8upyoCSSPPxnG0mnQUapvGcidOs7hDT8zhvhiUkrDOxkLbTeK2fqKkhWBIiv5WIeIAxvbXFPu0WuyqOzeIv9lv0YgnyqbTB1YwLqWGTgAM1UdsDQepn/bHAbpC2pVzh/XAeR29T0HtrpkuS/BR14R43ecAmbbag1YyC3npc9Vg=
Message-ID: <86802c440805011552t213b9badv926baeb0b4bc5227@mail.gmail.com>
Date: Thu, 1 May 2008 15:52:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <481A3AD6.1040905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <481A1D3A.5040202@zytor.com>
	 <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>
	 <481A31E2.2020800@zytor.com>
	 <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>
	 <481A356C.5090502@zytor.com>
	 <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>
	 <481A372C.5080808@zytor.com>
	 <86802c440805011444i56611b1ave44a714da7988fa@mail.gmail.com>
	 <481A3AD6.1040905@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 2:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > >
> > > >
> > > >
> > >  That's not the point.  I understand you want to flatten the layout.
> The
> > > point is: why do you need manual tunables for the algorithm to do the
> right
> > > thing?
> > >
> >
> > optimal result is not losing covering for ranges that is originally
> > covered, and still keep as many of spare mtrr entries for X server
> > driver.
> > we only have 8 mtrrs, could lose some covering because of run out of mtrr
> regs.
> > So we need to search it according to chunk/gran with ram ranges that
> > is defined by old mtrr layout.
> >
>
>  Yes.  You have a search space of less than 1000 possible combinations
> (64..20 bits), so it hardly is any reason to not search the entire universe
> of possibilities, even if by exhaustive search.

only search 78
2g, 1g, ...1m, and half matrix 13 * 6..

and don't need to search than 78.

also if we don't need to get the more spare regs than
mtrr_spare_reg_nr, we could search less... about 10 etc.

>
>  Now, if even that searching can't come up with the optimal solution (if one
> exists) in all cases, then the algorithm is broken.

because we only have 8 mtrrs, and user may specify mtrr_spare_reg_nr =
2 or 3 to get more entries for the graphics cards...
then can not the optimal setting without losing any covering.

so if the optimal is there (only need to search to 2g), it will catch it.

YH
