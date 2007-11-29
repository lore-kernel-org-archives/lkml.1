Return-Path: <linux-kernel-owner+w=401wt.eu-S1762577AbXK2RVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762577AbXK2RVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbXK2RVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:21:34 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:56718 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758815AbXK2RVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:21:33 -0500
Date: Thu, 29 Nov 2007 12:21:21 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: does /proc/sys/kernel/modprobe actually do anything?
In-Reply-To: <3ae72650711290914q162e81a8l9fbecf1a1196ba79@mail.gmail.com>
Message-ID: <alpine.LFD.0.9999.0711291218240.2902@localhost.localdomain>
References: <alpine.LFD.0.9999.0711290438060.13461@localhost.localdomain>  <b6fcc0a0711290207jf82e618uccecf922a22c4f33@mail.gmail.com>  <alpine.LFD.0.9999.0711290756090.29674@localhost.localdomain>
 <3ae72650711290914q162e81a8l9fbecf1a1196ba79@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Kay Sievers wrote:

> On Nov 29, 2007 1:58 PM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > On Thu, 29 Nov 2007, Alexey Dobriyan wrote:
> >
> > > On 11/29/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> > > > echo '#! /bin/sh' > /tmp/modprobe
> > > > echo 'echo "$@" >> /tmp/modprobe.log' >> /tmp/modprobe
> > > > echo 'exec /sbin/modprobe "$@"' >> /tmp/modprobe
> > > > chmod a+x /tmp/modprobe
> > > > echo /tmp/modprobe > /proc/sys/kernel/modprobe
> > > >
> > > >   i've tried that and i don't see that it does anything whatsoever.  i
> > > > ran modprobe under "strace" and it doesn't appear to make any effort
> > > > to check /proc/sys/kernel/modprobe.
> > >
> > > Kernel, not modprobe, checks /proc/sys/kernel/modprobe .
> >
> > actually, ignore that earlier query of mine, i've found the relevant
> > code under kernel/ in sysctl.c and sysctl_check.c and kmod.c.  but
> > it's still not clear why what is described in
> > Documentation/debugging-modules.txt (and shown above) doesn't work, so
> > i'm still open to suggestions.  thanks.
>
> Kernel code can request a module to be loaded by calling
> request_module(). The /proc/sys/kernel/modprobe value is the path to
> the binary which the kernel executes when this function is called.
> It is used by some modules, or if you open an existing device node
> which has no actual driver loaded.
>
> Most modules are loaded by device id's (modalias) of a device. The
> module is loaded by pure userspace tools and not by the kernel and
> therefore /proc/sys/kernel/modprobe is not involved at all in most
> module loading.
>
> The text in Documentation/debugging-modules.txt is purely about
> kernel module loading requests, and not helpful for the common
> module loading case.

i'd eventually come to a conclusion sort of like that.  so that
suggests that what's in Documentation/debugging-modules.txt should
really be updated to reflect that; otherwise, other folks might trip
across it like i did and wonder why it's just not working for them.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
