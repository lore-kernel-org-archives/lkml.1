Return-Path: <linux-kernel-owner+w=401wt.eu-S1946591AbXD3Spv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946591AbXD3Spv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946603AbXD3Spt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:45:49 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47723 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1946591AbXD3SpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:45:03 -0400
Date: Mon, 30 Apr 2007 11:44:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-mm1: many processes end up in D state
Message-Id: <20070430114449.1dad1ab2.akpm@linux-foundation.org>
In-Reply-To: <4af2d03a0704301114sc84b358td8781c91b8564c38@mail.gmail.com>
References: <46360DA7.6040003@gmail.com>
	<20070430110510.1f559d34.akpm@linux-foundation.org>
	<4af2d03a0704301114sc84b358td8781c91b8564c38@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007 20:14:05 +0200
"Jiri Slaby" <jirislaby@gmail.com> wrote:

> > > I have a problem with higher disk loads (e.g. running git-log or yum update).
> > > Many processes end up in D state and system is unusable -- I'm not able to run
> > > anything but smooth mouse moving when this happens.
> > >
> > > If I wait for a 20-30sec it becomes usable. This happens in 2.6.21-rc7-mm2 and
> > > also in 2007-04-28-05-06 broken-out snapshot. I think 2.6.21-rc6-mm1 worked
> > > fine, but I'm uncertain. If it is important, let me know to re-test.
> > >
> >
> > It is important, but I doubt if retesting 2.6.21-rc6-mm1 will clarify
> > things a lot.
> >
> > Could you try switching to a different IO scheduler please?  Anticipatory
> > would suit.
> 
> As I wrote below the sysrq-t, switch to noop didn't help, but it seems
> that it's harder to reproduce with that:
> 
> <cite it's_bad_to_write_anything_below_logs="true">
> Note that yum works on lvm on raid0 and git too, but on the another md volume.
> Both ext3s. Drivers are sata_promise and ata_piix (sata disk); CFQ scheduler.
> Using noop is no change (but seems to be harder to reproduce with it). I figured
> out that it probably happens when 2+ processes are on both "processors" (HT on
> P4) and are IO wait (multiload-applet shows red above the half).
> 
> Swap usage is 0 all the time.
> </cite>

My comprehension skills on Monday morning are even less than usual ;)

I would check the anticipatory scheduler as well, please.  I don't know
what no-op would do with a workload like that, but it probably isn't very
good.

You appear to believe that it's related to the CPU scheduler?  That's a bit
unexpected - it sounds more like a VFS/IO thing?  But stranger things have
happened.

I guess it's time to end the staircase experiment in -mm. 
http://userweb.kernel.org/~akpm/js.bz2 is my current rollup (against
2.6.21) minus staircase and related things.  Pretty please.
