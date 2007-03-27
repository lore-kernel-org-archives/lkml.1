Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbXC0Sgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbXC0Sgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934148AbXC0Sgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:36:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:50771 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934140AbXC0Sgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:36:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gHcieZzMR4qGiKbjBZPHGUlYoaRApqKnfGkqLBbDy3c45vt9Hoj7lK3trZHxcb8pHlA4Vn0r/SbFYYqX+xscBBqPGzFZk9FDyP0Vo7yUassxqR4GRB2qQ3+xI6FUiUmbWt5tFdT4fZlElSuBS1B7mS2WqzcHXhpRLcWwgQUyoKE=
Message-ID: <38b3b7c0703271136s799114fcndfaa6de8db52fc70@mail.gmail.com>
Date: Tue, 27 Mar 2007 20:36:38 +0200
From: "johann deneux" <johann.deneux@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: FF layer restrictions [Was: [PATCH 1/1] Input: add sensable phantom driver]
Cc: "Dmitry Torokhov" <dtor@insightbb.com>,
       "=?ISO-8859-1?Q?\"STenyaK_(Bruno_Gonz=E1lez)\"?=" <stenyak@gmail.com>,
       "Anssi Hannula" <anssi.hannula@gmail.com>,
       "Linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <46090BF2.2000105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2460126662758025813@fi.muni.cz> <46018FB8.1080601@gmail.com>
	 <38b3b7c0703211503s3a8ee177v5b149cfd5975de8c@mail.gmail.com>
	 <200703221150.12403.dtor@insightbb.com> <46090BF2.2000105@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> Dmitry Torokhov napsal(a):
> > On Wednesday 21 March 2007 18:03, johann deneux wrote:
> >> On 3/21/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> >>> Dmitry Torokhov napsal(a):
> >>>> On 3/21/07, johann deneux <johann.deneux@gmail.com> wrote:
> >>>>> I would suggest adding a new effect type (3d effect) and extending the
> >>>>> union in struct ff_effect.
> >>>>> Let me know if I'm too vague, I already suggested that solution but
> >>>>> got no answer. I wonder if my mail got lost, nobody understood what I
> >>>>> said, or if it's just a plain bad idea.
> >>>>>
> >>>> My concern with a new 3D effect is that it will be a very "simple"
> >>>> effect with only constant force apllied. That might be enough for
> >>>> phantom but may not be sufficient for future devices. If we add
> >>>> ability to specify a "plane" for an effect we will be able to add
> >>>> envelopes on top of more complex effects and get desired combined
> >>>> effcet.
> >>> I didn't get this too much, because I don't understand the FF layer well so
> >>> far. How is this going to work? Let's say, we have 3 torque values computed
> >>> in US, and this structure:
> >>>
> >>> struct ff_effect {
> >>>     __u16 direction;
> >>>     struct ff_trigger trigger;
> >>>     struct ff_replay replay;
> >>>
> >>>     struct ff_constant_effect {
> >>>         __s16 level;
> >>>         struct ff_envelope {
> >>>              __u16 attack_length;
> >>>              __u16 attack_level;
> >>>              __u16 fade_length;
> >>>              __u16 fade_level;
> >>>         };
> >>>     };
> >>> };
> >>>
> >>> and need to pass the three 16bits torques into s16 ioaddr[0..2]. How?
> >>>
> >> Stupid question,
>
> Sorry to be out for so long, maybe I'm stupid idiot, that understands
> nothing, but:

No, it's not you, there are still things that are unclear. For
instance I think Dmitry intended to combine several planes, which I
don't understand.

What we want is to specify a 3d vector, which can be done using two
angles and a magnitude.
One angle and the magnitude we already have in ff_effect, so all we
need is an additional angle, which can be specified using a new ioctl.
I originally thought it could be done without a new ioctl, just by
extending ff_struct, but that won't work.

>
> >> I have forgotten the details of ioctl: Wouldn't the
> >> following work?
>
> No, at least, as far as I understand this. I have computed _torques_, not
> forces vector (this was misleading info in my first post), the question is
> "how can I pass torques through plane and direction entries into KS?".

Torques and forces are both represented as 3d vectors. Are we
misunderstanding eachother maybe? By "vector" I mean a triplet of
numbers, when you say "torques" and "forces vector", do you mean that
each effect is composed of a bunch of torques?

-- 
Johann
