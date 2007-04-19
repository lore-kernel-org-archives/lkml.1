Return-Path: <linux-kernel-owner+w=401wt.eu-S2993161AbXDSH6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993161AbXDSH6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 03:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993162AbXDSH6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 03:58:18 -0400
Received: from holomorphy.com ([66.93.40.71]:41149 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993161AbXDSH6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 03:58:18 -0400
Date: Thu, 19 Apr 2007 00:57:46 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       ck list <ck@vds.kolivas.org>, Bill Huey <billh@gnuppy.monkey.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070419075746.GD31925@holomorphy.com>
References: <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org> <20070419031807.GA24512@wotan.suse.de> <20070418221432.e4dbcf4f.akpm@linux-foundation.org> <20070419063810.GA22418@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419063810.GA22418@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> wrote:
>> Yes, there are potential compatibility problems.  Example: a machine 
>> with 100 busy httpd processes and suddenly a big gzip starts up from 
>> console or cron.
[...]

On Thu, Apr 19, 2007 at 08:38:10AM +0200, Ingo Molnar wrote:
> hmmmm. How about the following then: default to nice -10 for all 
> (SCHED_NORMAL) kernel threads and all root-owned tasks. Root _is_ 
> special: root already has disk space reserved to it, root has special 
> memory allocation allowances, etc. I dont see a reason why we couldnt by 
> default make all root tasks have nice -10. This would be instantly loved 
> by sysadmins i suspect ;-)
> (distros that go the extra mile of making Xorg run under non-root could 
> also go another extra one foot to renice that X server to -10.)

I'd further recommend making priority levels accessible to kernel threads
that are not otherwise accessible to processes, both above and below
user-available priority levels. Basically, if you can get SCHED_RR and
SCHED_FIFO to coexist as "intimate scheduler classes," then a SCHED_KERN
scheduler class can coexist with SCHED_OTHER in like fashion, but with
availability of higher and lower priorities than any userspace process
is allowed, and potentially some differing scheduling semantics. In such
a manner nonessential background processing intended not to ever disturb
userspace can be given priorities appropriate to it (perhaps even con's
SCHED_IDLEPRIO would make sense), and other, urgent processing can be
given priority over userspace altogether.

I believe root's default priority can be adjusted in userspace as
things now stand somewhere in /etc/ but I'm not sure of the specifics.
Word is somewhere in /etc/security/limits.conf


-- wli
