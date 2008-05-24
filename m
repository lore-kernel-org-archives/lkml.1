Return-Path: <linux-kernel-owner+w=401wt.eu-S1762534AbYEXWqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762534AbYEXWqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 18:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYEXWqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 18:46:23 -0400
Received: from www.tglx.de ([62.245.132.106]:59281 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbYEXWqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 18:46:22 -0400
Date: Sun, 25 May 2008 00:46:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tom Spink <tspink@gmail.com>
cc: Greg KH <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
       Uwe Kleine-K??nig <Uwe.Kleine-Koenig@digi.com>,
       linux-kernel@vger.kernel.org,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable
 interrupts
In-Reply-To: <7b9198260805241534s1a548e16i583742db92be3789@mail.gmail.com>
Message-ID: <alpine.LFD.1.10.0805250036481.3295@apollo.tec.linutronix.de>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>  <20080523055527.GA28963@digi.com>  <20080523104454.4e2af6ec@bluebox.local>  <20080523091009.GA22821@digi.com>  <20080523120308.7bec1e1c@bluebox.local>  <20080523105604.GA23800@digi.com>
  <20080523135557.27fe4855@bluebox.local>  <20080524044354.GA8129@suse.de>  <alpine.LFD.1.10.0805250013450.3295@apollo.tec.linutronix.de> <7b9198260805241534s1a548e16i583742db92be3789@mail.gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 May 2008, Tom Spink wrote:
> 2008/5/24 Thomas Gleixner <tglx@linutronix.de>:
> > It makes a certain amount of sense to use write. You hold the device
> > file descriptor anyway for the read (wait for interrupt) operation,
> > so using the same file descriptor is not a too bad idea:
> 
> What do you think about my ioctl idea, earlier in the thread?

I think it's a pretty bad idea.
 
> >    while (!stop) {
> >
> >        /* wait for interrupt */
> >        read(fd);
> >
> >        do_stuff();
> >
> >        /*reenable interrupt */
> >        write(fd);
> >    }
> 
> So, instead of write, you'd use ioctl(fd, ...).

And what's the actual gain ?

> > I thought about using a sysfs entry for a while, but looking at the
> > actual use case made the write() solution a more natural choice.
> 
> I thought ioctl would be more natural, as [en,dis]abling interrupts is
> a "controlling" operation :-)

Oh no. We are not going to open the bottomless pit of ioctls in
UIO. Once we have an ioctl channel in place we have the same mess
which we want to avoid in the first place.

Also when a driver needs more than the obvious interrupt wait /
control functions (which are pretty symetric btw.) aside of the
mmapped access to the device then it does not belong into the category
of an UIO driver.

Thanks,

	tglx
