Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbYDVN1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbYDVN1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbYDVN0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:26:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41563 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573AbYDVN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:26:53 -0400
Subject: Re: [Bug 10489] Kprobe smoke test lockdep warning
From: Peter Zijlstra <peterz@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Adrian Bunk <bunk@kernel.org>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       bugme-daemon@bugzilla.kernel.org,
       jean-marc LACROIX <jeanmarc.lacroix@free.Fr>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <1208869770.7115.265.camel@twins>
References: <20080421150656.GJ6011@cs181133002.pp.htv.fi>
	 <480D1B14.7070806@redhat.com>  <1208869770.7115.265.camel@twins>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 15:26:31 +0200
Message-Id: <1208870791.7115.269.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-04-22 at 15:09 +0200, Peter Zijlstra wrote:
> On Mon, 2008-04-21 at 18:54 -0400, Masami Hiramatsu wrote:
> > Thank you for reporting.
> > 
> > Actually, kprobes tries to fixup thread's flags in post_kprobe_handler
> > (which is called from kprobe_exceptions_notify) by
> > trace_hardirqs_fixup_flags(pt_regs->flags). However, even the irq flag
> > is set in pt_regs->flags, true hardirq is still off until returning
> > from do_debug. Thus, lockdep assumes that hardirq is off without annotation.

Ah, can you clarrify? pt_regs->flags will only be set when returning to
the original trap site? in that case we should not need a lockdep
annotation I guess, unless its allowed and exptected for the int3 site
to change IRQ state.

