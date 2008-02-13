Return-Path: <linux-kernel-owner+w=401wt.eu-S933867AbYBMR6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933867AbYBMR6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 12:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755935AbYBMR6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 12:58:32 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:50259 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbYBMR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 12:58:31 -0500
Date: Wed, 13 Feb 2008 12:58:23 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Sam Ravnborg <sam@ravnborg.org>
cc: Josh Boyer <jwboyer@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: latest list of unused Kconfig variables
In-Reply-To: <20080213174636.GB12259@uranus.ravnborg.org>
Message-ID: <alpine.LFD.1.00.0802131250120.25604@localhost.localdomain>
References: <alpine.LFD.1.00.0802130353530.31183@localhost.localdomain> <20080213073242.5c069c25@zod.rchland.ibm.com> <alpine.LFD.1.00.0802131002310.28617@localhost.localdomain> <20080213093314.3220e29d@zod.rchland.ibm.com> <alpine.LFD.1.00.0802131038130.30959@localhost.localdomain>
 <20080213174636.GB12259@uranus.ravnborg.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
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
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Sam Ravnborg wrote:

> On Wed, Feb 13, 2008 at 10:44:27AM -0500, Robert P. J. Day wrote:
> > On Wed, 13 Feb 2008, Josh Boyer wrote:
> >
> > > OK.  Well all of your hits for 405EX, 440GRX, 440SPe, and
> > > WANT_DEVICE_TREE in arch/powerpc seem bogus.  I dunno if you prune
> > > those when reported or not.
> >
> > not normally, but i don't know what you mean by "bogus":
> >
> >   $ grep -r "config 405EX" *
> >   arch/powerpc/platforms/40x/Kconfig:config 405EX
> >   $
> >
> >   $ grep -r CONFIG_405EX *
> >   arch/powerpc/configs/makalu_defconfig:CONFIG_405EX=y
> >   arch/powerpc/configs/kilauea_defconfig:CONFIG_405EX=y
> >   $
>
> $ git grep 405EX | grep select
> arch/powerpc/platforms/40x/Kconfig:     select 405EX
> arch/powerpc/platforms/40x/Kconfig:     select 405EX
>
> So it is used.

ok, i see the flaw in my logic.  the Kconfig variable 405EX isn't
tested *directly* by anyone, it's simply used to further "select"
other variables, which my script doesn't take into account.

  config 405EX
        bool
        select IBM_NEW_EMAC_EMAC4
        select IBM_NEW_EMAC_RGMII

i don't think i'm quite ready to add that logic to a simple scanning
script.

oh, well.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
