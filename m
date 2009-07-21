Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZGUUgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZGUUgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755903AbZGUUgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:36:35 -0400
Received: from www.tglx.de ([62.245.132.106]:53094 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238AbZGUUgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:36:33 -0400
Date: Tue, 21 Jul 2009 22:30:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
In-Reply-To: <20090721160436.GD4352@dtor-d630.eng.vmware.com>
Message-ID: <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
References: <20090714100634.GA4054@elf.ucw.cz> <5d5443650907140320w334864f4uc1ee13ed32fdb874@mail.gmail.com> <20090715133627.GA2538@elf.ucw.cz> <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090721105924.GK4133@elf.ucw.cz>
 <20090721113642.GC13286@sirena.org.uk> <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com> <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com> <20090721124933.GA5668@rakim.wolfsonmicro.main>
 <20090721160436.GD4352@dtor-d630.eng.vmware.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009, Dmitry Torokhov wrote:

> On Tue, Jul 21, 2009 at 01:49:33PM +0100, Mark Brown wrote:
> > On Tue, Jul 21, 2009 at 06:00:07PM +0530, Trilok Soni wrote:
> > 
> > > Hopefully, this thread can give all details about threaded irq discussion.
> > 
> > > http://lkml.org/lkml/2009/2/27/255
> > 
> > Yes, I'm aware of that - I read it at the time.  It seemed to peter out
> > without any satisfactory solution, unfortunately.  There's two separate
> > issues here:
> > 
> >  - Ordinary devices on interrupt driven or slow buses like I2C.  These
> >    need something along the lines of request_threaded_irq() that's allows
> >    them to schedule the main IRQ handler outside hardirq context so
> >    that they can interact with the device.  They need to do something in
> >    hardirq context to disable the interrupt if it's level triggered but
> >    most of the time the only option they've got is to disable the IRQ
> >    and reenable it when the worker thread is done.  This is the issue
> >    here.

There is already a sane solution to the problem:

      See http://lkml.org/lkml/2009/7/17/174 

> >    My immediate thought when I noticed this was that we should probably
> >    fix request_threaded_irq() so that it's useful for them; I'd been
> >    intending to do some digging and try to understand why it is
> >    currently implemented as it is.

What's to fix there ? 
 
> >  - Multi-function devices like the twl4030 which have an interrupt
> >    controller on them and would like to expose that interrupt controller
> >    via the generic IRQ subsystem.  This was a large part of the
> >    discussion in the thread above is a much trickier problem.

Why ?

> > I've added the folks from Samsung posting the MELFAS MCS-5000 driver to
> > the thread since they're running into the same issue.
> > 
> 
> Let's also add Thomas and David since I believe they worked on the
> feature.
> 
> >From my part I would like to have the threaded IRQ available to all
> drivers since it seens to be hanlding driver shutdown cleanly and
> without races which is a big plus for me since very few drivers get it
> right.

:)

Thanks,

	tglx
