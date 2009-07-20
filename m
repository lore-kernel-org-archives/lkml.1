Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZGTSvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZGTSvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZGTSvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:51:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595AbZGTSvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:51:00 -0400
Subject: Re: s2r badness
From: Peter Zijlstra <peterz@infradead.org>
To: prasad@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Len Brown <lenb@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090720182045.GA5537@in.ibm.com>
References: <1247947383.4872.3.camel@laptop>
	 <alpine.LFD.2.00.0907182223450.11571@localhost.localdomain>
	 <20090720182045.GA5537@in.ibm.com>
Content-Type: text/plain
Date: Mon, 20 Jul 2009 20:50:44 +0200
Message-Id: <1248115844.23509.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-07-20 at 23:50 +0530, K.Prasad wrote:

> > > [   74.576953] ------------[ cut here ]------------
> > > [   74.576953] WARNING: at /usr/src/linux-2.6/kernel/softirq.c:143 local_bh_enable_ip+0x8b/0xc0()
> > > [   74.576953] Hardware name: 2242CTO

> > > [   74.576953] Pid: 5406, comm: bash Not tainted 2.6.31-rc3-tip #32
> > > [   74.576953] Call Trace:
> > > [   74.576953]  [<ffffffff8107401b>] ? local_bh_enable_ip+0x8b/0xc0
> > > [   74.576953]  [<ffffffff8106c838>] warn_slowpath_common+0x78/0xd0
> > > [   74.576953]  [<ffffffff8106c89f>] warn_slowpath_null+0xf/0x20
> > > [   74.576953]  [<ffffffff8107401b>] local_bh_enable_ip+0x8b/0xc0
> > > [   74.576953]  [<ffffffff814d08d9>] _spin_unlock_bh+0x19/0x20
> > > [   74.576953]  [<ffffffff810d2c77>] load_debug_registers+0x67/0x80
> > 
> > That's the hw breakpoint support stuff which does the spin_unlock_bh
> > at a point where interrupts are disabled. So that's a -tip tree issue,
> > not mainline.
> >
> 
> load_debug_registers() uses spin_(un)lock_bh() and not a spin-lock() to
> protect itself from flush_thread_hw_breakpoint() [which is invoked in
> softIRQ context].
> 
> I'd like to recreate this traceback to investigate and fix this. What
> steps, when done cause this message to appear?

Close the lid and open it again?

