Return-Path: <linux-kernel-owner+w=401wt.eu-S1757630AbYDUWyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757630AbYDUWyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753225AbYDUWyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:54:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYDUWyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:54:45 -0400
Message-ID: <480D1B14.7070806@redhat.com>
Date: Mon, 21 Apr 2008 18:54:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: ananth@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       bugme-daemon@bugzilla.kernel.org,
       jean-marc LACROIX <jeanmarc.lacroix@free.Fr>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Bug 10489] Kprobe smoke test lockdep warning
References: <20080421150656.GJ6011@cs181133002.pp.htv.fi>
In-Reply-To: <20080421150656.GJ6011@cs181133002.pp.htv.fi>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for reporting.

Actually, kprobes tries to fixup thread's flags in post_kprobe_handler
(which is called from kprobe_exceptions_notify) by
trace_hardirqs_fixup_flags(pt_regs->flags). However, even the irq flag
is set in pt_regs->flags, true hardirq is still off until returning
from do_debug. Thus, lockdep assumes that hardirq is off without annotation.

IMHO, one possible solution is that fixing hardirq flags right after
notify_die in do_debug instead of in post_kprobe_handler.

Thanks,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

