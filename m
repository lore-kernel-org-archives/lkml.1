Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbYFIIon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbYFIIon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 04:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYFIIoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 04:44:34 -0400
Received: from www.tglx.de ([62.245.132.106]:52923 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbYFIIod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 04:44:33 -0400
Date: Mon, 9 Jun 2008 10:44:12 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       lethal@linux-sh.org, tglx@linutronix.de
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080609084411.GA3223@local>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com> <20080608205455.GA3191@local> <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30806081812m532882e0p7ad3ef9a74f53337@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 10:12:09AM +0900, Magnus Damm wrote:
> >
> > The objection is that your code offers no advantages. What can we do
> > with your patch applied that we cannot do with uio_pdrv alone?
> 
> Yes, it is possible to have board or architecture specific hooks, but
> does that really make sense if the code is generic and can be reused
> by multiple architectures? I say it doesn't make sense at all.

So that's your answer when I ask what your code has to offer?

> 
> >> > If it's a device within the SoC, you won't use UIO for that. If you did,
> >> > your platform would depend on certain userspace software which is simply
> >> > crap. And devices outside the SoC are board specific.
> >>
> >> Why wouldn't we use UIO for device within the Soc?
> >
> > Can't you read? I've answered that in the lines above your question.
> 
> I'm sure there are blocks within the SoC that must be managed by the
> kernel, but that's not always the case. Certain things can be managed
> by user space just fine. For instance, video acceleration hardware.

There are standard kernel subsystems to handle such devices. You should
only make it a UIO driver if v4l, drm, fb doesn't work for some
important reason.

> 
> >> I've been doing
> >> that for quite some time now.
> >
> > Really? I haven't seen any such driver yet. IMO, support for everything
> > inside a SoC should be completely within the kernel, I wouldn't do it
> > with UIO. But it's up to the arch maintainer to decide that. Did you ask
> > him?
> 
> Regarding driver source, I have posted a user space test driver here:
> 
> http://article.gmane.org/gmane.linux.ports.sh.devel/3927
> 
> As for kernel driver source, you have it earlier in this thread. I'm
> planning on pushing my user space VIDIX driver upstream, but I'd like
> to get the kernel parts merged first or at least acked. This UIO
> specific piece of the puzzle unfortunately seems to take forever.
> Which really is a shame, because it's all very simple.

Why do you need that stuff that works only with irqs that are not
shared? Why don't you simply do it with uio_pdrv? Or a normal UIO
driver?
After a brief look over your userspace code, I cannot see why you need
any additions to the UIO core code.

> > Once more (for the last time): The technical argument against your patch
> > is that it offers no advantages. It makes other code more complicated,
> > less obvious, and less consistent. This might be OK if we had big
> > advantages in return, but this isn't the case.
> 
> I say:
> a) We need this for 5+ different SuperH hardware blocks.
> b) This approach can be used by most architectures.
> c) The code is architecture independent.
> 
> You say "it offers no advantages".

Yes, and your answer is the proof.

Thanks,
Hans

