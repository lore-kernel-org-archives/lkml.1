Return-Path: <linux-kernel-owner+w=401wt.eu-S1161159AbXBWRFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161159AbXBWRFg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161175AbXBWRFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:05:36 -0500
Received: from nz-out-0506.google.com ([64.233.162.226]:33094 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161159AbXBWRFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:05:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nGfLutNYzUOb50cLAHqxk2rwnE3Ifpo5LGz45HRaCq70XRZjZrn/Yn3po/BvpGw7fBBr034X4O2VBMSLeAXeGl7jCuOwQz2LheddZ/JDLf9kgNemx4BkcDSOQ31O7XT+4KCc50RyoleoCsxexaNGrXXnRxJlmW9Zo48N7Efwros=
Message-ID: <d120d5000702230905r6b50a1bbm3b71551f855cdf01@mail.gmail.com>
Date: Fri, 23 Feb 2007 12:05:33 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Richard Knutsson" <ricknu-0@student.ltu.se>
Subject: Re: [KJ][RFC][PATCH] BIT macro cleanup
Cc: "Milind Choudhary" <milindchoudhary@gmail.com>,
       kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz
In-Reply-To: <45DF1165.2080003@student.ltu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3b44d3fb0702222056k1d2a9b57q69a3555a09a9058e@mail.gmail.com>
	 <3b44d3fb0702230014x4ee4a1dewdc624c54b3635e15@mail.gmail.com>
	 <45DEAC45.7090105@student.ltu.se>
	 <3b44d3fb0702230215o2fbd5a3y25729e481a447149@mail.gmail.com>
	 <45DEF5EE.4030002@student.ltu.se>
	 <d120d5000702230657s1860efb3o6986277901f13d03@mail.gmail.com>
	 <45DF1165.2080003@student.ltu.se>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> Dmitry Torokhov wrote:
> > On 2/23/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> >> Milind Choudhary wrote:
> >> > On 2/23/07, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
> >> >> > +#define BITWRAP(nr)    (1UL << ((nr) % BITS_PER_LONG))
> >> >> >
> >> >> > & make the whole input subsystem use it
> >> >> > The change is huge, more than 125 files using input.h
> >> >> > & almost all use the BIT macro.
> >> >> It is as a big of change, but have you dismissed the "BIT(nr %
> >> >> BITS_PER_LONG)" approach?
> >> >
> >> > no..
> >> > but just looking at the number of places it is being used,
> >> > it seems that adding a new  macro would be good
> >> > which makes it look short n sweet
> >> You have a point there but I still don't think it should be in bitops.h.
> >> Why should we favor long-wrap before byte-wrap, so what do you think
> >> about doing:
> >>
> >> #define BITWRAP(x)      BIT((x) % BITS_PER_LONG)
> >>
> >> in input.h? Otherwise I think it should be call LBITWRAP (or something)
> >> to both show what kind it is and enable us to add others later.
> >
> > Why would you not want to have what you call bitwrap as a standard
> > behavior? Most placed to not use modulus because they know the kind of
> > data they are working with but should still be fine if generic
> > implementation did that.
> >
> Both because I find the name not as expressive as simple "BIT(x %
> something)",

I was not talking about name (I hate BITWRAP) but behavior.

> but mainly since it only enables wrapping of the long-type.

I'd provde BIT and separate LLBIT for ones who really need long long.
People who intereseted in smaller than BITS_PER_LONG bitmaps shoud use
your proposal - BIT(x % DESIRED_WITH) and BIT should do modulo
BITS_PER_LONG internally.

-- 
Dmitry
