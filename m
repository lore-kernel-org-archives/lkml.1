Return-Path: <linux-kernel-owner+w=401wt.eu-S1750929AbXB0Fym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929AbXB0Fym (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 00:54:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751411AbXB0Fym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 00:54:42 -0500
Received: from stardust.friedrich-kn.de ([80.237.152.89]:34506 "EHLO
	stardust.friedrich-kn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbXB0Fym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 00:54:42 -0500
X-Greylist: delayed 1911 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 00:54:42 EST
Date: Tue, 27 Feb 2007 06:22:39 +0100
From: Joerg Friedrich <Joerg.Friedrich@friedrich-kn.de>
To: David Miller <davem@davemloft.net>
Cc: j.j.green@sheffield.ac.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: sparc64 / bbc_i2c.c
Message-ID: <20070227052239.GA30083@stardust.friedrich-kn.de>
References: <1171978032.18442.11.camel@lax.shef.ac.uk> <20070225044754.1d849a8d.akpm@linux-foundation.org> <Pine.LNX.4.64.0702252352310.32309@parallax.ddns.shef.ac.uk> <20070226.101219.18306730.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070226.101219.18306730.davem@davemloft.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

David Miller schrieb am Montag, 26. Februar 2007 um 10:12:19 -0800:
> From: "J.J.Green" <j.j.green@sheffield.ac.uk>
> Date: Sun, 25 Feb 2007 23:58:48 +0000 (GMT)
> 
> > Hi Andrew
> > 
> > > The code around there looks relatively unbuggy to me.  Removing that
> > > remove_wait_queue() would be very bad - it would cause later stack
> > > corruption.
> > >
> > > msleep_interruptible() certainly shouldn't consume CPU like that.  Do we
> > > know where the CPU time is being spent?  The output of:
> > >
> > > readprofile -r
> > > sleep 10
> > > readprofile -n -v -m /boot/System.map | sort -n -k 3 | tail -40
> > >
> > > would tell us.
> > 
> > As was mentioned in another reply, this message by
> > Joerg Friedrich
> > 
> >    http://lists.debian.org/debian-sparc/2007/02/msg00045.html
> > 
> > gives a possible explanantion of where the time is going.
> > I applied the patch to the debian kernel sources for 2.6.18,
> > it applied cleanly and fixed the problem.
> 
> I've added Joerg's patch to my tree and will push it into
> -stable as well.
> 
> Reviewing this patch had been sitting deep in my backlog for weeks, I
> just never got around to it, sorry.

Can you just tell me if it's sufficient to check for  a return value >0
of wait_event_interruptible_timeout? I was not sure so I extended the
check to 
if ((val != -ERESTARTSYS) && (val > 0))

-- 
Yours,
Jörg Friedrich

There are only 10 types of people:
Those who understand binary and those who don't.
