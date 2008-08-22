Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbYHVIM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbYHVIM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 04:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbYHVIMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 04:12:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751972AbYHVIMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 04:12:38 -0400
Date: Fri, 22 Aug 2008 01:12:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mattia Dongili <malattia@linux.it>
Cc: Martin Filip <bugtraq@smoula.net>, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, stable@kernel.org
Subject: Re: cpufreq regression, unable to set lower frequency
Message-Id: <20080822011217.e5b594de.akpm@linux-foundation.org>
In-Reply-To: <20080821225537.GB20165@inferi.kami.home>
References: <1219341101.9264.4.camel@localhost>
	<20080821225537.GB20165@inferi.kami.home>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2008 07:55:37 +0900 Mattia Dongili <malattia@linux.it> wrote:

> On Thu, Aug 21, 2008 at 07:51:41PM +0200, Martin Filip wrote:
> > Hi LKML,
> > 
> > I've upgraded my kernel few days earlier and suddenly my cpufreqd
> > stopperd working. My configuration is this:
> > AC adapter connected:
> >   set scaling_max_freq and scaling_min_freq to maximal available
> > frequency
> > AC adapter disconnected:
> >   set scaling_max_freq to maximal available, scaling_min_freq to minimal
> > available.
> > 
> > When I connect AC adapter, everything works fine but when I disconnect
> > my adapter, everything remains on maximal frequency and in logs I can
> > see:
> > 
> > cpufreqd: cpufreqd_set_profile: Couldn't set profile "Powersave Low" set
> > for cpu0
> > 
> > After some tests I've traced problem to 
> > 
> > http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.25.y.git;a=commitdiff;h=53391fa20cab6df6b476a5a0ad6be653c9de0c46
>  
> what version of cpufrequtils are running? This error should be fixed in
> 004 (or later) with this patch:
> http://git.kernel.org/?p=utils/kernel/cpufreq/cpufrequtils.git;a=commit;h=b88f8975d27690e04e520b05a1ed66bf1e306ee6
> 

We don't require that people upgrade their userspace to
something which was written only a month ago so that 2.6.27 works
correctly.

Start here: http://lkml.org/lkml/2008/7/30/45 to see why.

It would be better to find a kernel change which will cause 2.6.27 to
support people's current cpufrequtils correctly.  Reverting
53391fa20cab6df6b476a5a0ad6be653c9de0c4 might be one approach.

otoh, 53391fa20cab6df6b476a5a0ad6be653c9de0c46 was written six
months ago and is in 2.6.25.x and (presumably) 2.6.26.x, from which
I assume this regression affects very few people.  So we _might_
be able to get away with it.
