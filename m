Return-Path: <linux-kernel-owner+w=401wt.eu-S933804AbXCUTWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933804AbXCUTWm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933813AbXCUTWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:22:42 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:54594 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933804AbXCUTWl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:22:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=k+yRzmAbkOB0R+YZwzJYlf4Xu5arTMbMnodtHQJiLtPURM3A+Ul39+FWET/hGlEp+C3rARjqV3v8SpPC0jgnNU/5hMoIHGKhGk4M0SEFHxUuDj6QmYe7cJ1ngNwd7T1MzNVrnL99PFBA4lrRXlKnPKzMbNel7+V3uMySu/xxiLc=
Message-ID: <d120d5000703211222j64fd22fbn1e06267790f8a569@mail.gmail.com>
Date: Wed, 21 Mar 2007 15:22:39 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "johann deneux" <johann.deneux@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Jiri Slaby" <jirislaby@gmail.com>,
       "=?ISO-8859-1?Q?STenyaK_(Bruno_Gonz=E1lez)?=" <stenyak@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <38b3b7c0703211202p29f7865cr34960c7ea708640e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz> <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
	 <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
	 <4601339C.6010706@gmail.com>
	 <38b3b7c0703211202p29f7865cr34960c7ea708640e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, johann deneux <johann.deneux@gmail.com> wrote:
> On 3/21/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> > STenyaK (Bruno González) napsal(a):
> > > On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > >> > I have a question: if the force is to be 3D, why only 3 possible
> > >> values?
> > >> > What would they be, 3 torques or 3 forces? In the case of car sims (ff
> > >> > steering wheels), only one axis of torque is usually used (except
> > >> for 6 dof
> > >> > platforms, as mentioned).
> > >> >
> > >>
> > >> I wonder if we could somehow extend or augment FF envelope se we could
> > >> specify a plane for the effect.. Then a vector could be represented by
> > >> a sum 3 constant effects in 3 separate planes and we could also use
> > >> spring and other effects as well.
> > >
> > > Ideally, afaik we should use:
> > > -3 values for translation force (linear force): x,y,z components of
> > > the force vector.
> > > -4 values for rotation force (torque): x,y,z,w components of the
> > > quaternion. You can also use euler angles (and i think there are
> > > another one or two notations), which is just 3 values, but i'm not
> > > sure it will be a correct decision (due to the gimbal lock problem,
> > > which may or may not be present in ff devices, dunno).
> >
> > So, the resolution is? Since I want no longer have out-of-kernel driver, I
> > need to know how to implement the phantom driver -- merge it `as is', i.e.
> > control through mmio or rewrite ff layer somehow, and in that case how?
> >
> > There seem to be only few possibilities:
> >
> > - new 3D effect, which will be problematic in any other future use, that may
> > need more than 3 axis. no matter if torques or vector is passed -- depending
> > on device and programmer (as I need to compute torques from forces in FP).
> > Maybe struct with 2x 3 axis is OK
> >
> > - "raw" effect, which may contain more axis, but this is ugly in Anssi's eyes
> >
> > - something else? (did I forget something)
> >
>
> I would suggest adding a new effect type (3d effect) and extending the
> union in struct ff_effect.
> Let me know if I'm too vague, I already suggested that solution but
> got no answer. I wonder if my mail got lost, nobody understood what I
> said, or if it's just a plain bad idea.
>

My concern with a new 3D effect is that it will be a very "simple"
effect with only constant force apllied. That might be enough for
phantom but may not be sufficient for future devices. If we add
ability to specify a "plane" for an effect we will be able to add
envelopes on top of more complex effects and get desired combined
effcet. I would not worry aboput extra memory needed on I-force like
devices because they just would not support additional "planes". What
about phantom? Would it have enough memory?

On the other hand if you guys (Anssi, Johann, Jiri...) decide that a
simple new 3d effect is the most efficient solution for now and will
be enough for a few years (till we get FF v2 API) I will merge it.

-- 
Dmitry
