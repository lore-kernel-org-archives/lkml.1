Return-Path: <linux-kernel-owner+w=401wt.eu-S1765996AbYEAVoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765996AbYEAVoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758483AbYEAVo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:44:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:36668 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761084AbYEAVo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jST2xA2SOEH4POoCdTB4WAabCxsPH4fpffyEU0zqqbfw6sC/YtwbzTu8uO45mC8mteL1K0H3gF46T07bAJvQ4x6e6XsQgK3Z/zfBTO7o0De0V1asighF6MzGnn2nJSgSbrD/M4Cfvd2xqEuRXONuwajwjv1OGMJlEJaOyoskwaI=
Message-ID: <86802c440805011444i56611b1ave44a714da7988fa@mail.gmail.com>
Date: Thu, 1 May 2008 14:44:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <481A372C.5080808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804272337.40130.yhlu.kernel@gmail.com>
	 <200805010100.34751.yhlu.kernel@gmail.com>
	 <200805011157.00693.yhlu.kernel@gmail.com>
	 <481A1D3A.5040202@zytor.com>
	 <86802c440805011402h1e452b57ma27ffa6ad7b50238@mail.gmail.com>
	 <481A31E2.2020800@zytor.com>
	 <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>
	 <481A356C.5090502@zytor.com>
	 <86802c440805011431i88dec8aiadcb143b5f7648b@mail.gmail.com>
	 <481A372C.5080808@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 2:33 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Yinghai Lu wrote:
>
> >
> > >  Overall, I'm feeling there is something really completely wrong if this
> > > needs manual tunables of any sort.
> > >
> >
> > the problem is BIOS set MTRR like BIG WB - SOME SAMLL UC to spare mtrr
> regs.
> >
> > but later X server driver want to set some range to WC. that already
> > is fallen in UC...
> >
>
>  That's not the point.  I understand you want to flatten the layout.  The
> point is: why do you need manual tunables for the algorithm to do the right
> thing?

optimal result is not losing covering for ranges that is originally
covered, and still keep as many of spare mtrr entries for X server
driver.
we only have 8 mtrrs, could lose some covering because of run out of mtrr regs.
So we need to search it according to chunk/gran with ram ranges that
is defined by old mtrr layout.

and if we can not find the optimal setting, user could select one
setting (chunk/gran size) to boot next time, but he will lose some
covering.
for some regions. later trim_mtrr will remove those range from e820 map

YH
