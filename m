Return-Path: <linux-kernel-owner+w=401wt.eu-S1761387AbXLMKXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761387AbXLMKXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 05:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXLMKX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 05:23:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54180 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644AbXLMKX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 05:23:26 -0500
Date: Thu, 13 Dec 2007 11:22:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Thomas Gleixner <tglx@linutronix.de>, Remy Bohmer <linux@bohmer.net>,
       Daniel Walker <dwalker@mvista.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Revert lazy irq disable for simple irqs
Message-ID: <20071213102259.GQ8977@elte.hu>
References: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0712121516400.22305@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> [This patch *is* for mainline Linux]
> 
> In commit 76d2160147f43f982dfe881404cfde9fd0a9da21 lazy irq disabling 
> was implemented, and the simple irq handler had a masking set to it.
> 
> Remy Bohmer discovered that some devices in the ARM architecture would 
> trigger the mask, but never unmask it. His patch to do the unmasking 
> was questioned by Russell King about masking simple irqs to begin 
> with. Looking further, it was discovered that the problems Remy was 
> seeing was due to improper use of the simple handler by devices, and 
> he later submitted patches to fix those. But the issue that was 
> uncovered was that the simple handler should never mask.
> 
> This patch reverts the masking in the simple handler.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

thanks, applied. This is for v2.6.24 too, right?

	Ingo
