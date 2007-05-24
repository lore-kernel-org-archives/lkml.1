Return-Path: <linux-kernel-owner+w=401wt.eu-S1761954AbXEXBhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761954AbXEXBhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 21:37:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXEXBhm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 21:37:42 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:18781 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756374AbXEXBhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 21:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=g/MQb+YWSic45BFGb+j9j81LJLjm5IFXZKsnKWbKFxORg5ilmLh4HmlTK4udYfzJMm/Kx6TPXZ0aVvBRlIK67MQU1uBpP4baHbfDGFxHsY8cld0rboELTEjxMb5707TodcCuq/3I2uIAafjIDS/XD8KOKheNzZoE/A63qQekEpE=
Message-ID: <2c0942db0705231837k2941b9a0l9bb7d7cdc7d35195@mail.gmail.com>
Date: Wed, 23 May 2007 18:37:38 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: 2.6.21-mm2: ACPI exception on resume
Cc: "Matt Mackall" <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070524002826.GA2644@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070520035259.GA13224@khazad-dum.debian.net>
	 <20070521230349.GA645@khazad-dum.debian.net>
	 <20070522224515.GW11115@waste.org>
	 <20070523001943.GA3743@khazad-dum.debian.net>
	 <20070523014825.GX11115@waste.org>
	 <20070523041958.GA15952@khazad-dum.debian.net>
	 <2c0942db0705222141se133553re06370476d436b12@mail.gmail.com>
	 <20070523125100.GA826@khazad-dum.debian.net>
	 <2c0942db0705231550x70432ceaw1d428d7a25ffe8aa@mail.gmail.com>
	 <20070524002826.GA2644@khazad-dum.debian.net>
X-Google-Sender-Auth: 381b3390aa2ad8ef
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Wed, 23 May 2007, Ray Lee wrote:
> > Which is the crux of my problem with your statement. I feel we
> > shouldn't give the wrong idea to those authors. They need to know that
> > the expectation is that 2.6.x is a stable series, and 2.6.x.y is for
> > dealing with unavoidable mistakes.
>
> Well, the only case where I feel a regression is justified is one where it
> is caused by a bug in the firmware or the hardware.

Here's the problem. Each of the people testing the kernel is a 'canary
in the coalmine.' If one person is having trouble, then it's likely
that there are ten more that will have the same issue. The real
problem here is that those other ten people aren't going to know how
to fix it, other than "it used to work, so obviously the kernel is now
doing something wrong."

This is particularly bad for firmware, where upgrading it may
introduce new regressions. I understand that there are broken
firmwares out there -- I have a laptop with one.  But there needs to
be a way to support broken systems and the sane ones simultaneously.
This is a requirement for the ACPI tree, for example, and it seems to
work.

All of this is assuming that the firmware really was at fault. It's
also possible that it's just doing something different than before,
and both behaviors are valid and should be dealt with gracefully.

> At which point my personal opinion is that users of firmware/hardware *that
> have a fix available* are to be told to apply the fix, unless the problem is
> so serious that it could potentially cause extreme damage (loss of human
> life, permanent hardware damage, major data loss).

Those are extreme. My point is that if you know who all those people
are, and are willing to contact them, then sure, that's viable.
Otherwise, the bottom line is that the kernel used to deal with a
problem gracefully, and now it doesn't. There's no telling how many
other people will get bit by the same problem, and most of those
people aren't going to know what to do about it, other than to
downgrade the kernel, and wait for it to magically get fixed by
someone else.

> If there is no fix the user can apply, then it really depends on how
> damaging it is to work around the issue for others: you don't punish those
> who have non-broken stuff to avoid problems for those that have broken
> stuff.

I understand your point of view, but another way to look at it is that
we always want to make forward progress on the code. If we don't, then
we're never going to have a good metric (measure) of how we're doing.

> Fortunately, most of the time one can come up with a fix that causes little
> to no loss to those with non-broken hardware/firmware.

And I'm sure those with the Big Brains(tm) can do so again.

Thanks,

Ray
