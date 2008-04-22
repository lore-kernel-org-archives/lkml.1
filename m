Return-Path: <linux-kernel-owner+w=401wt.eu-S1765110AbYDVTxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765110AbYDVTxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763251AbYDVTw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:52:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759300AbYDVTw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:52:56 -0400
Message-ID: <480E41D3.8040608@redhat.com>
Date: Tue, 22 Apr 2008 15:51:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Adrian Bunk <bunk@kernel.org>, ananth@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       bugme-daemon@bugzilla.kernel.org,
       jean-marc LACROIX <jeanmarc.lacroix@free.Fr>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [Bug 10489] Kprobe smoke test lockdep warning
References: <20080421150656.GJ6011@cs181133002.pp.htv.fi>	 <480D1B14.7070806@redhat.com>  <1208869770.7115.265.camel@twins>	 <1208870791.7115.269.camel@twins>  <480E034F.5@redhat.com> <1208880358.7115.285.camel@twins> <480E10FA.3050401@redhat.com>
In-Reply-To: <480E10FA.3050401@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Masami Hiramatsu wrote:
> processor's IF bit is changed when an iret(q) is issued.
> In other words, when returning from a debug/int3 exception.

By the way, when returning from an exception on x86-64, it seems
paranoidexit@entry_64.S doesn't use TRACE_IRQS_IRETQ except for
it executes swapgs, does it?

If not, I guess the lockdep on x86-64 may causes an warning
by below code:

spin_lock(...)
kprobe_target_function()
spin_unlock(...)

Thanks,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

