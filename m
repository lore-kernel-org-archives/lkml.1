Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbZFJVAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbZFJVAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756697AbZFJVAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:00:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57901 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbZFJVAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:00:08 -0400
Date: Wed, 10 Jun 2009 16:58:48 -0400
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cpufreq@vger.kernel.org, mark.langsdorf@amd.com
Subject: Re: S06cpuspeed/2637 is trying to acquire lock
	(&(&dbs_info->work)->work (was: Re: [PATCH 4/6] x86/cpufreq: use
	cpumask_copy instead of =)
Message-ID: <20090610205848.GA1445@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Yinghai Lu <yinghai@kernel.org>, Avi Kivity <avi@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	cpufreq@vger.kernel.org, mark.langsdorf@amd.com
References: <4A2835D8.6040903@kernel.org> <200906091627.45411.rusty@rustcorp.com.au> <alpine.LFD.2.01.0906090842120.6847@localhost.localdomain> <200906101552.17397.rusty@rustcorp.com.au> <20090610111035.GG27724@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610111035.GG27724@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 01:10:35PM +0200, Ingo Molnar wrote:
 > 
 > With a v2.6.30 based kernel i'm still getting a cpufreq lockdep 
 > warning:
 > 
 >  =======================================================
 >  [ INFO: possible circular locking dependency detected ]
 >  2.6.30-tip #10420
 >  -------------------------------------------------------
 >  S06cpuspeed/2637 is trying to acquire lock:
 >   (&(&dbs_info->work)->work){+.+...}, at: [<ffffffff8106553d>] __cancel_work_timer+0xd6/0x22a
 > 
 >  but task is already holding lock:
 >   (dbs_mutex){+.+.+.}, at: [<ffffffff8193d630>] cpufreq_governor_dbs+0x28f/0x335
 > 
 > This bug got introduced somewhere late in the .30-rc cycle, this box 
 > was fine before.

See the thread " [PATCH] remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)" 
Though there's a report that the last patch posted still doesn't fix the problem,
so we still don't have a quick fix suitable for -stable.

It's this .. http://bugzilla.kernel.org/show_bug.cgi?id=13493
b14893a62c73af0eca414cfed505b8c09efc613c fixed one locking problem, but
introduced this as a side-effect.  The whole thing is a mess really.

	Dave

