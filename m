Return-Path: <linux-kernel-owner+w=401wt.eu-S932514AbYEAV1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbYEAV1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 17:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757429AbYEAV0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 17:26:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:56350 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761219AbYEAV0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 17:26:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZvVaaSUli7p/gv85Ok711fJxCEURUQ30je2MHZakIxBwcGFVnITf6r82+0sIEQ0E7x20VtjMNK2sgBi/IHlers2puVfS6nSNxzPf53ARbfbRnWKX3hDtI2AIy9erKqcDdxMeWnJ6cTCq8rNP/My6SUkBFW7uqoX7oV1pxNo1uwU=
Message-ID: <86802c440805011420g78a6abberaae6b765663ed33b@mail.gmail.com>
Date: Thu, 1 May 2008 14:20:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete - auto detect v2
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Gabriel C" <nix.or.die@googlemail.com>,
       "Mika Fischer" <mika.fischer@zoopnet.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <481A31E2.2020800@zytor.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2008 at 2:10 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Yinghai Lu wrote:
>
> > On Thu, May 1, 2008 at 12:42 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > > Yinghai Lu wrote:
> > >
> > >
> > > > loop mtrr chunk_size and gran_size from 1M to 2G to find out optimal
> > > >
> > > value.
> > >  Why stopping at 2 GB?
> > >
> >
> > if you select 4g for chunk size, we don't need to convert that from
> > continuous to discrete to make X server driver happen.
> >
> > actually the code could support any chunk_size...
> >
> > for example: 16 g system
> > orginal:
> > 0-4g WB
> > 3.5g-4g UC
> > 4g-8g WB
> > 8g-16g WB
> > 16g-16.5g WB
> >
> > if you set chunk size to 16g, and gran size <= 512M
> > you will get
> > 0-16g WB
> > 3.5g-4g UC
> > 16g-16.5g WB
> >
> >
>
>  Yes, 16 GB systems are already mainstream; 32 GB is common, so I don't see
> any reason to stop at 2 GB.  Instead, it should loop up to the physical
> address size.

but our objective is that has 0xd0000000-0xe0000000 (WC) not to be
overlapping with other MTRR entries (UC)..

YH
