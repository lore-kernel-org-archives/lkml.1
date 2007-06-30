Return-Path: <linux-kernel-owner+w=401wt.eu-S1752690AbXF3TmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbXF3TmV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 15:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbXF3TmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 15:42:13 -0400
Received: from smtp3.Stanford.EDU ([171.67.20.26]:49484 "EHLO
	smtp3.stanford.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXF3TmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 15:42:12 -0400
Subject: Re: 2.6.21.5-rt17 on lenovo t61, some BUG's (lukewarm IQ?)
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: Ingo Molnar <mingo@elte.hu>
Cc: nando@ccrma.Stanford.EDU, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070630192403.GE3720@elte.hu>
References: <1183000802.4085.5.camel@cmn3.stanford.edu>
	 <20070630192403.GE3720@elte.hu>
Content-Type: text/plain
Date: Sat, 30 Jun 2007 12:42:10 -0700
Message-Id: <1183232530.14071.17.camel@cmn3.stanford.edu>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-30 at 21:24 +0200, Ingo Molnar wrote:
> * Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:
> 
> > Hi Ingo, this is happening in a brand new laptop, a Lenovo t61 with a 
> > 7700 processor and the Santa Rosa chipset.
> > 
> > Lukewarm IQ detected in hotplug locking
> > BUG: at kernel/cpu.c:44 lock_cpu_hotplug()
> 
> hm, that's an upstream kernel message. Cpu-hotplug locking is ... a bit 
> messy still. Does it otherwise work? (it should only affect sw-suspend 
> on SMP)

It seems to work (I'm typing this on that machine running rt17). But I'm
still testing things and I have certainly not gotten to the point of
really trying suspend. It is a brand new laptop with new'ish chipset and
stuff so lotsa small details to fix :-)

> > [BTW, I tried to unsuccessfully boot rt18 today in one of my CCRMA 
> > machines but the boot hung when trying to start the acpi daemon - this 
> > was on FC6, I'll try to find out more tomorrow. We are seeing some 
> > hungs with rt17 that I have not tried to diagnose yet]
> 
> do you still see this?

Yes I do. My previous report was not very precise. 

Trying to boot rt18 - this is on fc6 - seems more slugish than rt17
(very subjective), eventually it gets to "starting udev" and it hangs
there. I presume it is trying to start a device driver unsuccessfully
but I don't get any more information and can't get to single user to
find out more. 

Yesterday I noticed that _sometimes_ "starting udev" in rt17 takes some
time. So this may be something that got worse in rt18 as opposed to
something completely new in rt18. 

Sorry for the vageness and let me know if there's something I can do to
try to find out what's going on (looking at rc.sysinit I found there's
some kernel boot options that allow for more debugging but I did not
have time to try that). 

As for the hangs in rt17 I have not been able to find anything out. They
are very sporadic (surprise!) and so far I have found no clues or
commonality in what was happening when the hang occurs. 

-- Fernando


