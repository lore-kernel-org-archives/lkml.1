Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbXKZPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbXKZPzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 10:55:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXKZPzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 10:55:18 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:36417 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbXKZPzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 10:55:16 -0500
Date: Mon, 26 Nov 2007 10:53:10 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: can support for "rpm"-based package building just be dropped?
In-Reply-To: <Pine.LNX.4.64.0711261622060.19299@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.9999.0711261048050.24142@localhost.localdomain>
References: <alpine.LFD.0.9999.0711260352060.30676@localhost.localdomain> <2c0942db0711260658j5ce017e7ucce4c373748ed7b7@mail.gmail.com> <Pine.LNX.4.64.0711261622060.19299@fbirervta.pbzchgretzou.qr>
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

On Mon, 26 Nov 2007, Jan Engelhardt wrote:

>
> On Nov 26 2007 06:58, Ray Lee wrote:
> >On Nov 26, 2007 12:54 AM, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> >>   on current systems, "rpm" no longer has build capability and will
> >> fail thusly:
> >>
> >> rpm --target i386 -ta ../kernel-2.6.24rc3g2ffbb837dirty.tar.gz
> >> --target: unknown option
> >>
> >>   so it would make more sense to just require "rpmbuild" on the
> >> machine, would it not?
> >
> >Only on current machines. You'd break building kernel RPMs on older
> >systems that don't have rpmbuild installed.
>
> Those old machines probably do not even run a distro-fabricated gcc that
> would compile a git head kernel.

well, in a nutshell, the problem scenario is that it's entirely
possible to have a modern distro (say, fedora 8, like i'm using) on
which you have the latest "rpm" package installed, but not "rpmbuild".
at which point scripts/package/Makefile, based on this:

RPM := $(shell if [ -x "/usr/bin/rpmbuild" ]; then echo rpmbuild; \
                   else echo rpm; fi)

will select "rpm" as the value of the variable RPM, at which point
things go south in a hurry as soon as you try to build an rpm package
using $(RPM) aka "rpm".

perhaps a solution would be to have two variables -- RPM and RPMBUILD
-- and set them appropriately based on what the Makefile finds.  and,
of course, whine incessantly if you have an unworkable setup.

anyway, have at it.

rday

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
