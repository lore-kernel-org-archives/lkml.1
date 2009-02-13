Return-Path: <linux-kernel-owner+w=401wt.eu-S1761197AbZBMOoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761197AbZBMOoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbZBMOn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:43:59 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:56969 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753038AbZBMOn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:43:58 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah0FABQRlUlMQWt2/2dsb2JhbACBbtEPhBgG
Date: Fri, 13 Feb 2009 09:43:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       akpm <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: irq-disabled vs vmap vs text_poke
Message-ID: <20090213144346.GA857@Krystal>
References: <1234529407.6519.28.camel@twins> <20090213125505.GE18462@wotan.suse.de> <1234530138.6519.38.camel@twins> <20090213130450.GB9346@elte.hu> <20090213142521.GB31922@Krystal> <1234535626.6519.113.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1234535626.6519.113.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:42:12 up 43 days, 14:40,  4 users,  load average: 0.40, 0.38,
	0.30
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Fri, 2009-02-13 at 09:25 -0500, Mathieu Desnoyers wrote:
> > * Ingo Molnar (mingo@elte.hu) wrote:
> > > 
> > > * Peter Zijlstra <peterz@infradead.org> wrote:
> > > 
> > > > > I think I got a mostly working patch cobbled together sitting here
> > > > > somewhere. I was waiting for some _really_ good use case before spending
> > > > > more time on it. I would prefer if at all possible to do vmap operations
> > > > > in sleepable, process context.
> > > > 
> > > > Agreed, I think we want to fix text_poke() and make the vmap/vunmap()
> > > > ops yell louder at violations of these rules.
> > > > 
> > > > I'm just totally clueless wrt text_poke() hence this email ;-)
> > > 
> > > also, this started triggering yesterday for the first time - and never
> > > saw it before. Has some commit caused this side-effect?
> > > 
> > > It triggers during kprobes self-test - has that been improved recently?
> > > 
> > 
> > When is this self-test run ? If it's at early boot while still in UP
> > with interrupts off, kprobes should probably use text_poke_early()
> > rather than text_poke().
> 
> Looking at the dmesg it looks to be post smp-init, so its late init
> calls.
> 
> I think its the do_initcalls() from do_basic_setup(). So the machine
> should be mostly up and running.

Here with 2.6.29-rc4 (commit 8e4921515c1a379539607eb443d51c30f4f7f338).
I don't seem to get any warning with a might_sleep() in text_poke.

Kprobe smoke test started
Kprobe smoke test passed successfully

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
