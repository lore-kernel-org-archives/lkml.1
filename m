Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbXCUTCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbXCUTCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 15:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933699AbXCUTCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 15:02:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:43779 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbXCUTCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 15:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sjeSdet//6Rh+QuXsf1GluTZT9oQNs02BlUiJ+hiOrdu9Af5Vo1NGdp/gdA08BW+/tabKWZQULvtn8iQMHkSfqcVxE3t3nKXTArgggdUUHBIjvywuAjZF8D7oh7F2XnKuGVbeSaPMG1e92ZomnM5kuy94MyjeeiWvyK9fV2Cjio=
Message-ID: <38b3b7c0703211202p29f7865cr34960c7ea708640e@mail.gmail.com>
Date: Wed, 21 Mar 2007 20:02:26 +0100
From: "johann deneux" <johann.deneux@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "=?ISO-8859-1?Q?\"STenyaK_(Bruno_Gonz=E1lez)\"?=" <stenyak@gmail.com>,
       "Dmitry Torokhov" <dmitry.torokhov@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <4601339C.6010706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz>
	 <38b3b7c0703131450v2646e63fj2be4b9dda7f928c0@mail.gmail.com>
	 <45F722CE.9000602@gmail.com>
	 <d120d5000703140802jb48bc74tbbe7ee2b120b1798@mail.gmail.com>
	 <45F82626.8000108@gmail.com> <45F83930.4060401@gmail.com>
	 <8e4ff20a0703141147n4b690ab8g4cc8138d1ecc94e1@mail.gmail.com>
	 <d120d5000703141213k6554f7f6o58e4a9da1aa6a20a@mail.gmail.com>
	 <8e4ff20a0703141218r3add7923n74470b5e16f58c5c@mail.gmail.com>
	 <4601339C.6010706@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/21/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> STenyaK (Bruno González) napsal(a):
> > On 3/14/07, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> >> > I have a question: if the force is to be 3D, why only 3 possible
> >> values?
> >> > What would they be, 3 torques or 3 forces? In the case of car sims (ff
> >> > steering wheels), only one axis of torque is usually used (except
> >> for 6 dof
> >> > platforms, as mentioned).
> >> >
> >>
> >> I wonder if we could somehow extend or augment FF envelope se we could
> >> specify a plane for the effect.. Then a vector could be represented by
> >> a sum 3 constant effects in 3 separate planes and we could also use
> >> spring and other effects as well.
> >
> > Ideally, afaik we should use:
> > -3 values for translation force (linear force): x,y,z components of
> > the force vector.
> > -4 values for rotation force (torque): x,y,z,w components of the
> > quaternion. You can also use euler angles (and i think there are
> > another one or two notations), which is just 3 values, but i'm not
> > sure it will be a correct decision (due to the gimbal lock problem,
> > which may or may not be present in ff devices, dunno).
>
> So, the resolution is? Since I want no longer have out-of-kernel driver, I
> need to know how to implement the phantom driver -- merge it `as is', i.e.
> control through mmio or rewrite ff layer somehow, and in that case how?
>
> There seem to be only few possibilities:
>
> - new 3D effect, which will be problematic in any other future use, that may
> need more than 3 axis. no matter if torques or vector is passed -- depending
> on device and programmer (as I need to compute torques from forces in FP).
> Maybe struct with 2x 3 axis is OK
>
> - "raw" effect, which may contain more axis, but this is ugly in Anssi's eyes
>
> - something else? (did I forget something)
>

I would suggest adding a new effect type (3d effect) and extending the
union in struct ff_effect.
Let me know if I'm too vague, I already suggested that solution but
got no answer. I wonder if my mail got lost, nobody understood what I
said, or if it's just a plain bad idea.

For future devices with more than 3 FF-enabled axes, we can just do
the same, or develop a whole new API. There shouldn't be any worry.

-- 
Johann
