Return-Path: <linux-kernel-owner+w=401wt.eu-S1754842AbZJTGOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbZJTGOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 02:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753282AbZJTGOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 02:14:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39494 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbZJTGOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 02:14:31 -0400
Date: Tue, 20 Oct 2009 08:14:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: tglx@linutronix.de, hpa@zytor.com, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Withdraw: [PATCH] x86-64: fix another kernel data leak to
	32-bit processes
Message-ID: <20091020061415.GD8550@elte.hu>
References: <4ADD7124020000780001AD37@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADD7124020000780001AD37@vpn.id2.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jan Beulich <JBeulich@novell.com> wrote:

> >Unfortunately I didn't realize that the other instances of branches 
> >to int_ret_from_sys_call also need fixing when preparing the previous 
> >similar patch. The issue fixed here was in fact introduced by an 
> >earlier patch of mine (295286a89107c353b9677bc604361c537fd6a1c0, i.e. 
> >in 2.6.28, but through stable now also present in 2.6.27), making 
> >kernel stack contents potentially visible through R8...R11 when an 
> >this or earlier syscall got interrupted prior to the handler being 
> >able to decrement the stack pointer (such that the space normally 
> >used by those registers within pt_regs would get overwritten by the 
> >interrupt handler stub).
> 
> That analysis wasn't right after all - there's a CLEAR_RREGS in each 
> of the modified paths already, so the change is unnecessary (and 
> adding redundant code). Please don't apply it.
> 
> >While touching the code, I also swapped the branch pairs so that the 
> >static branch prediction logic would consider the syscall-number-in- 
> >range case the taken path.
> 
> If this would seem a worthwhile change, I can re-send it as a 
> separate, lower priority patch...

Please do - thanks!

	Ingo
