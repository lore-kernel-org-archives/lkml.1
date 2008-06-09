Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbYFINVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbYFINVL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 09:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbYFINU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 09:20:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51171 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbYFINU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 09:20:59 -0400
Date: Mon, 9 Jun 2008 15:20:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] __down_common: use signal_pending_state()
Message-ID: <20080609132031.GA1737@elte.hu>
References: <20080604170906.GA10276@tv-sign.ru> <20080604173633.GI3549@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604173633.GI3549@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jun 04, 2008 at 09:09:06PM +0400, Oleg Nesterov wrote:
> > Cleanup. __down_common() can use the new signal_pending_state() helper.
> 
> This is a bad optimisation.  __down_common gets inlined and the 
> constant 'state' versions are optimised away for the versions which 
> don't apply.
> 
> NAK this patch.

well but we had a schedule() bug around this whole topic of 
TASK_KILLABLE, so i'd say robustness trumps micro-optimizations. Is this 
really a big issue? The dual-ness of TASK_KILLABLE checks is a bit ugly, 
and it led to a bug as well.

	Ingo
