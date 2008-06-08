Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYFHUz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYFHUz6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 16:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754614AbYFHUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 16:55:47 -0400
Received: from www.tglx.de ([62.245.132.106]:36043 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597AbYFHUzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 16:55:46 -0400
Date: Sun, 8 Jun 2008 22:54:57 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       Uwe.Kleine-Koenig@digi.com, gregkh@suse.de, akpm@linux-foundation.org,
       lethal@linux-sh.org, tglx@linutronix.de
Subject: Re: [PATCH] uio_pdrv: Unique IRQ Mode
Message-ID: <20080608205455.GA3191@local>
References: <20080604060826.17162.46972.sendpatchset@rx1.opensource.se> <20080604101144.GA3207@local> <aec7e5c30806041825o4c6c859fp8380063e9384622@mail.gmail.com> <20080605090916.GA3198@local> <aec7e5c30806050246t248abc39vbc1e71d4475a0a0d@mail.gmail.com> <20080605112744.GB3198@local> <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aec7e5c30806080319y7b9b6a89icacbfa67b117fb2b@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 07:19:25PM +0900, Magnus Damm wrote:
> >>
> >> So your main objection against this patch is that you cannot use it
> >> with shared interrupts?
> >
> > I think I've explained my objections detailed enough.
> 
> It's still unclear to me. Please make a brief summary of your objections.

The objection is that your code offers no advantages. What can we do
with your patch applied that we cannot do with uio_pdrv alone?

> >
> > If it's a device within the SoC, you won't use UIO for that. If you did,
> > your platform would depend on certain userspace software which is simply
> > crap. And devices outside the SoC are board specific.
> 
> Why wouldn't we use UIO for device within the Soc? 

Can't you read? I've answered that in the lines above your question.

> I've been doing
> that for quite some time now.

Really? I haven't seen any such driver yet. IMO, support for everything
inside a SoC should be completely within the kernel, I wouldn't do it
with UIO. But it's up to the arch maintainer to decide that. Did you ask
him?

> 
> >> >> The patch contains no board specific code,
> >> >> and it is independent of both architecture and cpu model.
> >> >
> >> > Every platform device driver depends on board support.
> >>
> >> Is that so? I suggest that you have a look at the mfd drivers and think again.
> >
> > All I said about board support also applies to platform support files
> > like at91sam9263_devices.c, I'm simply talking about the file where you
> > define your struct platform_device.
> 
> Oh, I see. That's cpu specific code in my mind.

It's completely unimportant if your struct platform_device appears in
platform-, board-, or cpu-support. Or elsewhere. I won't let myself be
tricked into a discussion about terms.

> 
> >> >> > So, NAK to this until somebody convinces me that I completely missed the
> >> >> > point.
> >> >>
> >> >> We can reuse this driver for _many_ different SuperH processor models.
> >> >> Most of these processor models even have more than one hardware block
> >> >> that can be exported to user space using this uio_pdrv driver in
> >> >> "Unique IRQ Mode". There is nothing board specific with this at all,
> >> >> so yes, I think you are missing the point.
> >> >
> >> > First, I won't accept anything that changes the current UIO behaviour.
> >> > If uio_info->irq is not set, then uio_register_device will fail. That's
> >> > it. Your patch redefines the meaning of irq-not-set if uio_pdrv is used.
> >>
> >> How is this changing the UIO behavior? I'm modifying the uio_pdrv
> >> driver, which is a driver that you didn't even write yourself.
> >
> > uio_pdrv is a generic driver, so I consider it part of the UIO
> > framework. It adds new possibilities for authors of UIO platform device
> > drivers (which are the vast majority of all UIO drivers). It is not just
> > another UIO driver, but part of the system. It'll appear in UIO
> > documentation, I'll explain it in future UIO presentations, and so on.
> >
> > And I consider it my job to make sure that such generic code is clean,
> > obvious, and consistent.
> 
> Would you like me to write longer comments? Or some slides?

;-)

> 
> >> And yet
> >> you seem to have very strong feelings against this patch.
> >
> > I explained why. My reasons are purely technical, please don't take this
> > as a personal offense.
> 
> No offense taken. But I can't really see your technical arguments. 

Once more (for the last time): The technical argument against your patch
is that it offers no advantages. It makes other code more complicated,
less obvious, and less consistent. This might be OK if we had big
advantages in return, but this isn't the case.
Furthermore, your approach works only on certain platforms. But that
doesn't matter anymore, because the above is already enough to NAK your
patch. We won't add code just because it could be done.

> If something in my code is unclear please ask before NAK.

If I post a patch, it is my job to make it clear what advantages we have
if we apply it. And no, nothing is unclear with your patch.

> 
> > Unfortunately, I'm one of the two UIO maintainers, so I feel obliged to
> > review your patch and give my opinion. That doesn't mean I'm
> > the big boss who makes the final decision. I can be critized and
> > overridden. If Greg loves your patch and merges it, fine. Try it.
> 
> Maybe I will. =)

Did you notice that in this thread nobody spoke up to support your
patch?

Thanks,
Hans
