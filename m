Return-Path: <linux-kernel-owner+w=401wt.eu-S1752021AbYLWObS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbYLWObS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbYLWObE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:31:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55333 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbYLWObC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:31:02 -0500
Date: Tue, 23 Dec 2008 15:30:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC -tip 2/4] x86: uaccess: introduce __{get|put}_user
	exception handling framework
Message-ID: <20081223143046.GD29151@elte.hu>
References: <49507534.5080401@ct.jp.nec.com> <495075B0.9020104@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495075B0.9020104@ct.jp.nec.com>
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


* Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:

> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> 
> Impact: introduce new framework
> 
> Introduce exception handling framework.
> __{get|put}_user_ex_try() begins exception block and
> __{get|put}_user_ex_catch() ends block and if an exception occurred in this
> block using __{get|put}_user_ex, direct jump to __{get|put}_user_ex_catch()
> and err is set to specified value.

ha, this tickled ~12 year old memories: back then Linus came up with a 
very, very similar scheme, for user-copy exception handling.

Such a scheme would be elegant, creates more compact code (we can use 
conditional results directly in branch instructions instead of having to 
export them into registers), and it makes sense syntactically, but it 
doesnt work: GCC is free to reorder (or eliminate) basic blocks and these 
labels can lose their relationship.

So this cannot be done via inline assembly right now, it needs some 
compiler help. Sniff :)

	Ingo
