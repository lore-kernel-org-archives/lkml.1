Return-Path: <linux-kernel-owner+w=401wt.eu-S1946170AbXBPU5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946170AbXBPU5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946208AbXBPU5g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:57:36 -0500
Received: from 81-174-11-161.f5.ngi.it ([81.174.11.161]:52283 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946170AbXBPU5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:57:36 -0500
Date: Fri, 16 Feb 2007 21:57:47 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Jan Dittmer <jdi@l4x.org>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com
Message-ID: <20070216205747.GC4641@enneenne.com>
References: <20070216185230.GO8882@enneenne.com> <45D60C62.5080806@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D60C62.5080806@l4x.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 1/1] LinuxPPS: Pulse per Second support for Linux
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 16, 2007 at 08:56:18PM +0100, Jan Dittmer wrote:

> Drop the linux prefix. It's in the linux kernel after all.

Ok.

> > +PROCFS support
> > +--------------
> 
> New features shouldn't introduce new /proc stuff.

It's a must? I can leave procfs for backward compatibility with old
utilities?

> Add to MAINTAINERS

Ok.

> Your way to hook into lp and 8250 is pretty gross. It should at least be
> possible to deactivate it via the kernel command line, but it would be
> a lot nicer to have pps_lp and pps_8250 modules which you can load. Also

I think it's not possible... however the Russell's suggestions should
go in that direction.

> what happens if you've multiple lp ports? How do you control which to
> grab?

No way... I can add a specific flag as for uart lines or a kernel
module parameter.

> - don't implement your own dbg() stuff, use dprintk and friends
> - drop the inlines, gcc will do the right thing.

Ok. Ok.

> Perhaps just implement empty defines for the none pps cases and get
> rid of the ifdefs? But this should really be controllabe via
> sysfs or such.

Mmm... let me think about howto implement that...

> help text

Ok.

> help text and difference to CLIENT_LP?

Ok.

> Why no dynamically allocated array?

It's easier! :P

Also it's very difficult having more that 3 or 4 PPS sources in a
system.

> I wouldn't bet on that.

Why not? =:-o

Also locking instructions may add extra code and delay the timestamp
recording...

> Doesn't match filename

I'm going to fix it.

> > +++ b/drivers/pps/procfs.c
> 
> I'd drop that completely.

:'(

> You read the comment above your line?

No, sorry. I'm going to choose another id number... or can I keep 17?

> These should use dprintk and friends

Ok.

> Isn't something like 4 more reasonable (lp + 8250 + ktimer?)

It should be enought...

> I think you can drop the volatiles, there was a discussion some time ago
> that they mostly waste of words.

I see...

> This one looks pretty fishy. After the check you normally want
> to use it, don't you? And then you already lost the guarantee.

You are right...

> > +#define to_class_dev(obj) container_of((obj), struct class_device, kobj)
> 
> pretty generic name.

I should change it?

> Have you thought about 32/64bit issues?

No. I have no 64 bits machine to test the code...

> Function in .h?

I'm going to check it.

Thanks for your suggestions,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
