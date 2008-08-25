Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbYHYRyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbYHYRyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 13:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753996AbYHYRyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 13:54:43 -0400
Received: from testure.choralone.org ([194.9.77.134]:47992 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbYHYRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 13:54:42 -0400
Date: Mon, 25 Aug 2008 13:55:47 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, cpufreq@vger.kernel.org,
       Alok Kataria <akataria@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [BUG] cpufreq: constant cpu_khz
Message-ID: <20080825175547.GA26131@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	cpufreq@vger.kernel.org, Alok Kataria <akataria@vmware.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	"H. Peter Anvin" <hpa@zytor.com>
References: <1219646032.20732.10.camel@twins> <1219664106.8515.50.camel@twins> <20080825123926.GC8663@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080825123926.GC8663@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2008 at 02:39:26PM +0200, Ingo Molnar wrote:
 > 
 > * Peter Zijlstra <peterz@infradead.org> wrote:
 > 
 > > > I noticed that my sched_clock() was slow on a number of machine, so 
 > > > I started looking at cpufreq.
 > > 
 > > The below seems to fix the problem for me, but I don't have enough 
 > > clue to know if its the correct fix, please advise.
 > 
 > > -	set_cyc2ns_scale(tsc_khz_ref, freq->cpu);
 > > +	set_cyc2ns_scale(tsc_khz, freq->cpu);
 > 
 > hm, that too is due to the tsc.c unification - Alok Cc:-ed. Applied your 
 > fix to x86/urgent.

ACKed-by: Dave Jones <davej@redhat.com>

Good catch Peter.  I'm puzzled how that bug was latent on 64bit
for so long with no-one realising though.

	Dave

-- 
http://www.codemonkey.org.uk
