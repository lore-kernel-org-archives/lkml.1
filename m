Return-Path: <linux-kernel-owner+w=401wt.eu-S1764037AbZAOSBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764037AbZAOSBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 13:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbZAOSA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 13:00:56 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:41289 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbZAOSAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 13:00:55 -0500
Date: Thu, 15 Jan 2009 11:00:53 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com,
       linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com,
       arjan@linux.intel.com, andi.kleen@intel.com, suresh.b.siddha@intel.com,
       harita.chilukuri@intel.com, douglas.w.styner@intel.com,
       peter.xihong.wang@intel.com, hubert.nueckel@intel.com,
       chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: Mainline kernel OLTP performance update
Message-ID: <20090115180052.GG29283@parisc-linux.org>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <1232028766.5966.10.camel@localhost.localdomain> <20090115094442.b6394544.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090115094442.b6394544.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 09:44:42AM -0800, Andrew Morton wrote:
> > Me too.  Anecdotally, I haven't noticed this in my lab machines, but
> > what I have noticed is on someone else's laptop (a hyperthreaded atom)
> > that I was trying to demo powertop on was that IPI reschedule interrupts
> > seem to be out of control ... they were ticking over at a really high
> > rate and preventing the CPU from spending much time in the low C and P
> > states.  To me this implicates some scheduler problem since that's the
> > primary producer of IPI reschedules ... I think it wouldn't be a
> > significant extrapolation to predict that the scheduler might be the
> > cause of the above problem as well.
> > 
> 
> Good point.
> 
> The context switch rate actually went down a bit.
> 
> I wonder if the Intel test people have records of /proc/interrupts for
> the various kernel versions.

I think Chinang does, but he's out of office today.  He did say in an
earlier reply:

> I took a quick look at the interrupts figure between 2.6.24 and 2.6.27.
> i/o interuputs is slightly down in 2.6.27 (due to reduce throughput).
> But both NMI and reschedule interrupt increased.  Reschedule interrupts
> is 2x of 2.6.24.

So if the reschedule interrupt is happening twice as often, and the
context switch rate is basically unchanged, I guess that means the
scheduler is doing a lot more work to get approximately the same
results.  And that seems like a bad thing.

Again, it's worth bearing in mind that these are all RT tasks, so the
underlying problem may be very different from the one that both James and
I have observed with an Atom laptop running predominantly non-RT tasks.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
