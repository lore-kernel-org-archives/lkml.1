Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786Ab0ABPly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab0ABPly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 10:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666Ab0ABPlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 10:41:53 -0500
Received: from mail1.radix.net ([207.192.128.31]:48506 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab0ABPlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 10:41:53 -0500
Subject: Re: [suspend/resume] Re: userspace notification from module
From: Andy Walls <awalls@radix.net>
To: Daniel Borkmann <danborkmann@googlemail.com>
Cc: =?UTF-8?Q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>,
       linux-kernel@vger.kernel.org
In-Reply-To: <6f52f5b81001020715i79d2ea1j33443fa50fbb593c@mail.gmail.com>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl>
	 <4B3F5264.7000008@gmail.com> <58607309.1e2f721f.4b3f57c0.807d3@o2.pl>
	 <6f52f5b81001020713j5435cfadr1143806a9026adc2@mail.gmail.com>
	 <6f52f5b81001020715i79d2ea1j33443fa50fbb593c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Jan 2010 10:40:24 -0500
Message-Id: <1262446824.3058.11.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-02 at 16:15 +0100, Daniel Borkmann wrote:
> Hi Bartłomiej,
> 
> 2010/1/2 Bartłomiej Zimoń <uzi18@o2.pl>
> >
> > This looks like more simple and could be good, after all i think about sending this
> > module here to add to kernel. So if this solution could be ok i will start to code this part.
> >
> > Question is now what signal to choose to not terminate process and to be compatible
> > with rest of Linux kernel?
> 
> Have a look at linux/signal.h. There's a section for non-POSIX
> signals. May be you
> could add a SIGSUS or sth similar into that list with a free signal
> number to stay
> compatible with the rest of the numbers.
> 
> Cool thing is that you now will have a kind of "observer" principle:
> Don't call us, we call you ;)


Why not:

a. write a module that implements a device node that supports poll(),
and

b. have a user space process select() on the fd for read or exception
notification

?

Regards,
Andy

> Cheers,
> Daniel Borkmann


