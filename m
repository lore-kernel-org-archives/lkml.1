Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYFCDcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYFCDcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 23:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbYFCDcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 23:32:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37772 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbYFCDcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 23:32:01 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3454377"
Message-ID: <4844BB41.7000605@qualcomm.com>
Date: Mon, 02 Jun 2008 20:32:17 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Oeser <ioe-lkml@rameria.de>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com> <1212446707.6269.26.camel@lappy.programming.kicks-ass.net> <48447C75.8040203@qualcomm.com> <200806030156.00155.ioe-lkml@rameria.de>
In-Reply-To: <200806030156.00155.ioe-lkml@rameria.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Oeser wrote:
> Hi Max,
> Hi Peter,
> 
> On Tuesday 03 June 2008, Max Krasnyansky wrote:
>> Ingo, I just wanted to elaborate on what Peter is saying. That CPU will still
>> have to be _booted_ properly. It may be used for hard- and soft- interrupt
>> processing, workqueues (internal kernel queuing mechanism) and kernel timers.
> 
> Oh! Didn't know that user process scheduling is so much 
Not sure what you meant here. Stuff that I listed has nothing to do with user
process scheduling.

>> In your particular case you're much much much better off with doing
>> 	echo 0 > /sys/devices/system/cpuN/online
>> either during initrd stage or as a first init script.
>> That way bad cpu will be _completely_ disabled.
> 
> The initrd is from the distribution. I have no sane way to change it
> fast and permanent. Can I change the initrd and still have a certified
> RHEL or SLES? Are there initrd hooks, which survive packet installation?
That's why I mentioned "first init" script. You can create a simple init.d
compliant script that runs with priority 0 (see /etc/init.d/network for
example). That should be early enough.

> I would really appreciate some way to keep the kernel from using 
> a CPU at all to do fault isolation. If possible not even booting it.
How does isolcpu= boot option helps in this case ?
I suppose the closes option is maxcpus=. We can probably add ignorecpus= or
something to handle your use case but it has nothing to do with isolcpus=.

> Bootparameters survived all distro fiddling so far. I love them!
So do custom init.d scripts.

> 
> Try to convince a hardware vendor, that you don't have a software bug.
> Try to convince him that you didn't break the hardware by swapping it around.
> 
> So I'll ACK removing isolcpus, if we get a better replacement boot option.
I think you're missing the point here. It's like saying
"Lets not switch to electric cars because I use gasoline to kill weeds".

As I mentioned before, cpus listed in the isolcpus= boot option will still
handle hard-/soft- irqs, kernel work, kernel timers. You are much better off
using cpu hotplug (ie putting bad cpu offline). Feel free to propose
ignorecpus= option in a separate thread.

Max





