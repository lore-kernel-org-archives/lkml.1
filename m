Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYEHMtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYEHMtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 08:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbYEHMtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 08:49:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54701 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYEHMtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 08:49:04 -0400
Date: Thu, 8 May 2008 09:48:20 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Alistair John Strachan <alistair@devzero.co.uk>, Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc1
Message-ID: <20080508094820.33ea42f4@gaivota>
In-Reply-To: <4820EB69.9090907@s5r6.in-berlin.de>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
	<20080504160904.GF19717@sgi.com>
	<Pine.LNX.4.64.0805051656180.3218@bombadil.infradead.org>
	<200805060902.25835.alistair@devzero.co.uk>
	<20080506073134.424780a3@gaivota>
	<48206C73.80509@s5r6.in-berlin.de>
	<20080506161346.183f367c@gaivota>
	<4820B524.5080100@s5r6.in-berlin.de>
	<20080506170623.53732e78@gaivota>
	<4820C3D8.6040403@s5r6.in-berlin.de>
	<20080506193928.5acfc84d@gaivota>
	<4820EB69.9090907@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 May 2008 01:36:09 +0200
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Mauro Carvalho Chehab wrote:
> > On Tue, 06 May 2008 22:47:20 +0200
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> Or another idea:
> >>
> >> Copy _all_ dependencies of drivers which can be selected by "...if 
>     ^^^^
> >> VIDEO_HELPER_CHIPS_AUTO" to VIDEO_HELPER_CHIPS_AUTO.
> > 
> > I actually did this for tuners, on this changeset (still not at mainstream):
> > http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=d10b3c6817fb3fed8e6cd6d64d47c187a615c952
> 
> Yes...  Except that it is very dangerous to /move/ dependencies, as you 
> are apparently doing in that patch.  When you use "select" somewhere, 
> you should generally /copy/ dependencies.
> 
> Although something like
> 
> config VIRTUAL_META_OPTION
> 	depends on REAL_DEPENDENCY
> 
> config THE_REAL_THING
> 	depends on VIRTUAL_META_OPTION
> 
> does work if THE_REAL_THING actually depends on REAL_DEPENDENCY, it is 
> safer if this dependency stays there, i.e.
> 
> config THE_REAL_THING
> 	depends on REAL_DEPENDECY
> 
> or
> 
> config THE_REAL_THING
> 	depends on REAL_DEPENDENCY && VIRTUAL_META_OPTION
> 
> or whatever, or equivalent constructs involving "if"..."endif".
> 
> (I presume that for example MEDIA_TUNER_TDA827X does indeed have a build 
> dependency on DVB_CORE && I2C.)

No, the dependency of this file is currently wrong. In the case of those
tuners, all have the same dependencies: DVB or V4L and I2C. That's the reason
why I've removed the individual dependencies. Yet, two drivers need a select
(xc3028 and xc5000 needs to select FW_LOADER - so, only those two drivers are
also dependent of HOTPLUG).


Cheers,
Mauro
