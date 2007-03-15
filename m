Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360AbXCOUnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbXCOUnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbXCOUnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:43:21 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:60056 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbXCOUnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XNy+ibRTBxkCVTAqGFw1nt9exnfoj6eV9IF1wCGNVAfuh1MxKzyq5YNVqkTjfiJlwbjHCN//5tNuFhSThLdfWaSe4Oob9wyT2bBe84SPbTa55xdJV8dfjn44CtITzILO4GtC1QG5uQbPUg3Q0JeOt11AN443Utc1A9MTn6MsawY=
Message-ID: <38b3b7c0703151343i1e9299d2iab132cc74a65a3f5@mail.gmail.com>
Date: Thu, 15 Mar 2007 21:43:18 +0100
From: "johann deneux" <johann.deneux@gmail.com>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "=?ISO-8859-1?Q?STenyaK_(Bruno_Gonz=E1lez)?=" <stenyak@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Jiri Slaby" <jirislaby@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz>
	 <d120d5000703070856of068f19k62c5a7ce1f829336@mail.gmail.com>
	 <4af2d03a0703130919nb4893b1ja9ec795dcf4bf53c@mail.gmail.com>
	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
	 <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On 3/14/07, STenyaK (Bruno González) <stenyak@gmail.com> wrote:
> >
> >
> > On 3/14/07, Anssi Hannula <anssi.hannula@gmail.com> wrote:
> > > >> Do we have any idea if there any users of FF out there?
> > > >
> > > > At least me :). I'm using it for wheel and joystick in modules for
> > locally
> > > > developped multiplatform virtual reality system.
> > >
> > > Wine and BZflag come to mind, though I think the support is quite
> > > limited in both.
> > >
> >
> > There's also vDrift (racing sim), they added support very recently.
> > I plan to add it in my car sim too, but there's still nothing coded.
> >
> > I have a question: if the force is to be 3D, why only 3 possible values?
> > What would they be, 3 torques or 3 forces? In the case of car sims (ff
> > steering wheels), only one axis of torque is usually used (except for 6 dof
> > platforms, as mentioned).
> >
>
> I wonder if we could somehow extend or augment FF envelope se we could
> specify a plane for the effect.. Then a vector could be represented by
> a sum 3 constant effects in 3 separate planes and we could also use
> spring and other effects as well.

I don't think struct ff_envelope is a good candidate: Spring effects
don't have any envelope.
We have plenty of space for new effect types. Why not add a bunch of
new types, and add more structs in the ff_effect union?

The other option where you somehow manage to specify planes and
combine several effects is a good solution for devices where the
driver is responsible for storing effects, but it's wasteful for
I-Force-like devices where the effects are stored on the device. You
would be using two (or more) effects in the device's memory where only
one would be used if you used all the potential of the device. That
is, unless the driver is smart enough to merge effects, but that seems
hard.

-- 
Johann
