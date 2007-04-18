Return-Path: <linux-kernel-owner+w=401wt.eu-S2992959AbXDRXU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992959AbXDRXU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 19:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992968AbXDRXU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 19:20:28 -0400
Received: from mailhub.hp.com ([192.151.27.10]:37499 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992959AbXDRXU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 19:20:27 -0400
X-Greylist: delayed 1412 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 19:20:27 EDT
From: "Bob Picco" <bob.picco@hp.com>
Date: Wed, 18 Apr 2007 18:56:52 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Christian Hesse <mail@earthworm.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
Subject: Re: CFS and suspend2: hang in atomic copy
Message-ID: <20070418225652.GC10564@localhost>
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu> <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418220228.GA14536@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:	[Wed Apr 18 2007, 06:02:28PM EDT]
> 
> * Christian Hesse <mail@earthworm.de> wrote:
> 
> > > although probably your suspend2 problem is still not fixed, it's 
> > > worth a try nevertheless. Which suspend2 patch did you apply, and 
> > > was it against -rc6 or -rc7?
> > 
> > You are right again. ;-)
> > 
> > Linux 2.6.21-rc7
> > Suspend2 2.2.9.11 (applies cleanly to -rc7)
> > CFS v3 (without any additional patches)
> > 
> > And it still hangs on suspend.
> 
> what's the easiest way for me to try suspend2? Apply the patch, reboot 
> into the kernel, then execute what command to suspend? (there's a 
> confusing mismash of initiators of all the suspend variants. Can i drive 
> this by echoing to /sys/power/state?)
> 
> 	Ingo
I had hoped to collect more data with CFS V2. It crashes in
scale_nice_down for s2ram when attempting to disable_nonboot_cpus. 
So part of traceback looks like (typed by hand with obvious omissions):

scale_nice_down
update_stats_wait_end - not shown in traceback because inlined
pick_next_task_fair
migration_call
task_rq_lock
notifier_call_chain
_cpu_down
disable_nonboot_cpus
...

This is standard -rc7 with V2 CFS applied. It could be a completely
unrelated issue. I'll attempt to debug further tomorrow.

bob
