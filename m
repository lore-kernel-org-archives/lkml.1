Return-Path: <linux-kernel-owner+w=401wt.eu-S1761628AbYDUOVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761628AbYDUOVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 10:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbYDUOVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 10:21:42 -0400
Received: from mail.queued.net ([207.210.101.209]:3239 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347AbYDUOVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 10:21:41 -0400
Date: Mon, 21 Apr 2008 10:24:17 -0400
From: Andres Salomon <dilinger@queued.net>
To: Mitch Bradley <wmb@firmworks.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       jordan.crouse@amd.com
Subject: Re: [PATCH 1/2] OLPC: Add support for calling into Open Firmware
Message-ID: <20080421102417.6de71391@ephemeral>
In-Reply-To: <480C1286.3040307@firmworks.com>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
	<20080419092544.378664a8@ephemeral>
	<20080419133909.5aa6b63e@ephemeral>
	<86802c440804200334t5cdcd100rfc41e9b1bf379109@mail.gmail.com>
	<480C0582.9010509@firmworks.com>
	<86802c440804202015h2605eff7vc733874dd1f22261@mail.gmail.com>
	<480C1286.3040307@firmworks.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008 18:05:26 -1000
Mitch Bradley <wmb@firmworks.com> wrote:

> 
> 
> Yinghai Lu wrote:
> > On Sun, Apr 20, 2008 at 8:09 PM, Mitch Bradley <wmb@firmworks.com> wrote:
> >   
> >>
> >>  Yinghai Lu wrote:
> >>
> >>     
> >>> how about changing to ofw_32.c?
> >>>
> >>> YH
> >>>
> >>>
> >>>       
> >>  Is your suggestion to change the filename from "ofw.c" to "ofw_32.c"?  That
> >> seems like a good idea to me.
> >>     
> >
> > Yes.
> >
> > BTW,  why olpc need OFW runtime service?
> > why not just put the info in in ram with some signiture, so
> > kernel/util just need to loot at the table if needed?
> >   
> 
> In SPARC land, at least on SunOS and Solaris, it was very convenient for 
> debugging to interrupt the OS with Stop-A and use OFW to inspect the 
> system state.  That was especially handy for live crash analysis.  Dumps 
> are useful as far as they go, but they often fail to capture detailed 
> I/O device state.
> 
> I was hoping to do that on x86 too.  So far we (OLPC) haven't 
> implemented a sysrq hook to enter OFW, but I haven't given up hope yet.  
> It doesn't cost much to leave OFW around, but once you decide to eject 
> it, you can't easily get it back.
> 

I'm not actually convinced that we *do* want to keep OFW resident in memory,
especially given the memory tricks we need to play.  I also don't actually
like the OFW interface that we.  The debugging aspect of it was a
compelling argument up until a week ago (when kernel debuggers started
finally finding their way into the kernel).

However, until we clean up the promfs stuff, there's no chance of getting
an OFW device tree upstream.


> Apple made the early decision to eject OFW and just keep a device tree 
> table.  That decision was probably due to several factors, including the 
> rather lame state of Apple's first OFW implementation and the complexity 
> of their OS startup process at the time (which included "trampolining" 
> to a 68000 emulator to run their legacy code).  Once they went down that 
> path, the die was cast, and the PowerPC community got used to the "OFW 
> ends up as just a table" idea.
> 
> >   


-- 
Need a kernel or Debian developer?  Contact me, I'm looking for contracts.
