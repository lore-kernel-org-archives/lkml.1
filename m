Return-Path: <linux-kernel-owner+w=401wt.eu-S2993232AbXDSLud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993232AbXDSLud (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 07:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993238AbXDSLud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 07:50:33 -0400
Received: from omta05sl.mx.bigpond.com ([144.140.93.195]:25907 "EHLO
	omta05sl.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993232AbXDSLuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 07:50:32 -0400
Message-ID: <4627577B.7050204@bigpond.net.au>
Date: Thu, 19 Apr 2007 21:50:19 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070419031807.GA24512@wotan.suse.de> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu> <20070419075746.GD31925@holomorphy.com>
In-Reply-To: <20070419075746.GD31925@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta07sl.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Thu, 19 Apr 2007 11:50:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>>> Yes, there are potential compatibility problems.  Example: a machine 
>>> with 100 busy httpd processes and suddenly a big gzip starts up from 
>>> console or cron.
> [...]
> 
> On Thu, Apr 19, 2007 at 08:38:10AM +0200, Ingo Molnar wrote:
>> hmmmm. How about the following then: default to nice -10 for all 
>> (SCHED_NORMAL) kernel threads and all root-owned tasks. Root _is_ 
>> special: root already has disk space reserved to it, root has special 
>> memory allocation allowances, etc. I dont see a reason why we couldnt by 
>> default make all root tasks have nice -10. This would be instantly loved 
>> by sysadmins i suspect ;-)
>> (distros that go the extra mile of making Xorg run under non-root could 
>> also go another extra one foot to renice that X server to -10.)
> 
> I'd further recommend making priority levels accessible to kernel threads
> that are not otherwise accessible to processes, both above and below
> user-available priority levels. Basically, if you can get SCHED_RR and
> SCHED_FIFO to coexist as "intimate scheduler classes," then a SCHED_KERN
> scheduler class can coexist with SCHED_OTHER in like fashion, but with
> availability of higher and lower priorities than any userspace process
> is allowed, and potentially some differing scheduling semantics. In such
> a manner nonessential background processing intended not to ever disturb
> userspace can be given priorities appropriate to it (perhaps even con's
> SCHED_IDLEPRIO would make sense), and other, urgent processing can be
> given priority over userspace altogether.
> 
> I believe root's default priority can be adjusted in userspace as
> things now stand somewhere in /etc/ but I'm not sure of the specifics.
> Word is somewhere in /etc/security/limits.conf

This is sounding very much like System V Release 4 (and descendants) 
except that they call it SCHED_SYS and also give SCHED_NORMAL tasks that 
are in system mode dynamic priorities in the SCHED_SYS range (to avoid 
priority inversion, I believe).

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
