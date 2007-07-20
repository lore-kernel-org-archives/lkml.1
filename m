Return-Path: <linux-kernel-owner+w=401wt.eu-S933393AbXGTSV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393AbXGTSV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbXGTSVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:21:51 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39870 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762AbXGTSVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:21:50 -0400
Date: Fri, 20 Jul 2007 11:21:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Juergen Beisert <juergen127@kreuzholzen.de>,
       Andres Salomon <dilinger@queued.net>,
       TAKADA Yoshihito <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       Jordan Crouse <jordan.crouse@amd.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu
 unstable
Message-Id: <20070720112118.0521ecf5.akpm@linux-foundation.org>
In-Reply-To: <p73ir8gwl7g.fsf@bingen.suse.de>
References: <20070715.210036.157242351.takada@mbf.nifty.com>
	<200707191052.50047.juergen127@kreuzholzen.de>
	<200707191125.47079.ak@suse.de>
	<200707191225.26047.juergen127@kreuzholzen.de>
	<p73ir8gwl7g.fsf@bingen.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 Jul 2007 15:56:51 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Juergen Beisert <juergen127@kreuzholzen.de> writes:
> 
> > Hi Andi,
> > 
> > On Thursday 19 July 2007 11:25, Andi Kleen wrote:
> > > On Thursday 19 July 2007 10:52:48 Juergen Beisert wrote:
> > > > On Thursday 19 July 2007 10:22, Andi Kleen wrote:
> > > > > > Wow, that's a really cool bug; nice work!  Don't forget to update
> > > > > > arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.
> > > > > >  It needs to include processor-cyrix.h.
> > > > >
> > > > > It also needs some big fat comments
> > > >
> > > > No problem. Where to add?
> > >
> > > Where the inlines are defined.
> > >
> > > Also can you please resubmit full patches with full description
> > > and Signed off lines, not incrementals? Thanks.
> > 
> > Find attached. Hope its ok now.
> 
> For future reference:
> - Please send the patches inline if possible

+1!

> - Generate them from top level (so path start with linux...) 

+2!

> 
> I fixed it all up

I have a sad little patch from Nick here which adds a new
include/asm-x86_64/processor-cyrix.h.  I guess this patch broke the x86_64
build.

 arch/i386/kernel/cpu/cpufreq/gx-suspmod.c |    2 +-
 arch/i386/kernel/cpu/cyrix.c              |    2 +-
 arch/i386/kernel/cpu/mtrr/cyrix.c         |    1 +
 arch/i386/kernel/cpu/mtrr/state.c         |    1 +
 include/asm-i386/processor-cyrix.h        |   30 ++++++++++++++++++++++++++++++
 include/asm-i386/processor.h              |   11 -----------
 include/asm-x86_64/processor.h            |   11 -----------

Some of those .c files will be used by x86_64 too.
