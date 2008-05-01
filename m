Return-Path: <linux-kernel-owner+w=401wt.eu-S1764975AbYEAVbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764975AbYEAVbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759539AbYEAVb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:31:29 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:3628 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbYEAVb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=OREq6o0f0tpG1iPaI12McCm8uFYpTv/dbxsqi8ur7RosgDTAGYqp0IoTSOB5UL+jqwwvaZphTzkMhNp5maWOQij2KAFkEGmfll+pB33nxAG4Xm2eVjy4G3Z3PrPPidiZfvEpP+x78grhWfc3D63qoyK+3SeNGuXGRzmN1CpmkeA=
Message-ID: <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>
Date: Thu, 1 May 2008 14:31:16 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <481A356C.5090502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200804292025.58268.yhlu.kernel@gmail.com>
	 <200805010100.34751.yhlu.kernel@gmail.com>
	 <200805011157.00693.yhlu.kernel@gmail.com>
	 <481A1D3A.5040202@zytor.com>
	 <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>
	 <481A31E2.2020800@zytor.com>
	 <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>
	 <481A356C.5090502@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 2:26 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > >
> > > >
> > > >
> > >  Yes, 16 GB systems are already mainstream; 32 GB is common, so I don't
> see
> > > any reason to stop at 2 GB.  Instead, it should loop up to the physical
> > > address size.
> > >
> >
> > but our objective is that has 0xd0000000-0xe0000000 (WC) not to be
> > overlapping with other MTRR entries (UC)..
> >
> >
>
>  So, pray tell, how comes this algorithm can come up with a non-solution to
> the problem presented to it?
>
>  Overall, I'm feeling there is something really completely wrong if this
> needs manual tunables of any sort.

the problem is BIOS set MTRR like BIG WB - SOME SAMLL UC to spare mtrr regs.

but later X server driver want to set some range to WC. that already
is fallen in UC...

YH
