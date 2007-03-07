Return-Path: <linux-kernel-owner+w=401wt.eu-S965510AbXCGOW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965510AbXCGOW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 09:22:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965526AbXCGOW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 09:22:27 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:45138 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965510AbXCGOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 09:22:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=geOKfEqeNTWE3jXRboUweH4AFnYpmosVmTlxNqw4JnrNxsiOmerkELsziUuU2hBH/DZ868Kgl3NLBfdkqiSzAUMmPWQEvYM5zyMJSSYW8DRMpHG6QB8/Mnk61gDNAWfusOrn4UirW/xhdazC80vSgVzO1sozJL6o0FHGRId9FpI=
Message-ID: <d120d5000703070622h6d4225abm19da7032f69182e2@mail.gmail.com>
Date: Wed, 7 Mar 2007 09:22:24 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Ash Milsted" <thatistosayiseenem@gawab.com>
Subject: Re: 2.6.21-rc2 regression vs. 2.6.20: AT keyboard only works with pci=noacpi
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, vojtech@suse.cz
In-Reply-To: <20070307120004.0bab0f76.thatistosayiseenem@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070303151424.3b08c33e.thatistosayiseenem@gawab.com>
	 <20070304142350.7c3c79af.thatistosayiseenem@gawab.com>
	 <20070307120004.0bab0f76.thatistosayiseenem@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/7/07, Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> On Sun, 4 Mar 2007 14:23:50 +0000
> Ash Milsted <thatistosayiseenem@gawab.com> wrote:
>
> > On Sat, 3 Mar 2007 15:14:24 +0000
> > Ash Milsted <thatistosayiseenem@gawab.com> wrote:
> >
> > > Hi,
> > > With 2.6.21-rc2-git1 I have a problem with my ps/2 port keyboard - it only works
> > > with one of the following on the command-line:
> > >  - nolapic
> > >  - irqfixup
> > >  - pci=noacpi
> > > Otherwise it gets stuck with the numlock on.
> > > The following options have no effect:
> > >  - nohz=off (who knows eh?)
> > >  - pci=nomsi
> > >
> snip
> > >
> > > Ash
> >
> > Just checked 2.6.21-rc2-mm1, still has the problem.
> > Also, acpi=noirq fixes it too.
> > To clarify, the problem is that my ps/2 port keyboard is completely frozen
> > on boot - usually it gets activated when udev probes for hardware (my kernel
> > config is highly modular). It worked fine with 2.6.20 and earlier with acpi
> > taking care of interrupt routing.
> >
> > Ash
>
> Any thoughts on this? It still occurs with 2.6.21-rc3. Here's my config
> in case that helps. You'll see that I have swap-prefetch patched in (I
> also have RDSL and some VM changes in there), but I have confirmed that
> the problem occurs with no extra patches. By the way, I tested mm1 with
> a rather different config (I used my distro package) and still saw the
> problem.
>

Your config looks fine so it must be some ACPI change that affected
IRQ routing. If IRQ's not being delievered AT keyboard probe will time
out. You said that it broke between 2.6.20 and 2.6.20-rc2.. Have you
tried -rc1?
 .
> Also, you should probably ignore that bit above where I suggest the
> keyboard driver is being loaded as a module, because of course it
> isn't.. Yet it does start responding (with pci=noacpi) at about that
> time that udev does its thing.

Tha happens because actual keyboard/mouse probing is offloaded to
kseriod thread so nothing happens untul it actually gets scheduled.

-- 
Dmitry
