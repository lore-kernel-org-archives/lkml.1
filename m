Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYLSWgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYLSWgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 17:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYLSWgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 17:36:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46564 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753604AbYLSWgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 17:36:13 -0500
Date: Fri, 19 Dec 2008 23:35:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Toshikazu Nakayama <nakayama.ts@ncos.nec.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: fix discarding message when recursion_bug
Message-ID: <20081219223558.GC13409@elte.hu>
References: <494BE687.2040700@ct.jp.nec.com> <20081219215347.GG2351@elte.hu> <494C1D20.9000008@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494C1D20.9000008@ct.jp.nec.com>
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

> Ingo Molnar wrote:
> > * Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
> > 
> >> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >>
> >> Impact: fix
> >>
> >> When recursion_bug is true, kernel discards original message because printk_buf
> >> contains recursion_bug_msg with NULL terminator. The sizeof(recursion_bug_msg)
> >> makes this, use strlen() to get correct length without NULL terminator.
> >>
> >> Reported-by: Toshikazu Nakayama <nakayama.ts@ncos.nec.co.jp>
> >> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> >> ---
> >>  kernel/printk.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > Good one - applied to tip/core/printk, thanks!
> > 
> > Btw., i'm curious: in what situation was such recursion observed, and how 
> > did the kernel behave? You saw a truncated recursion message in dmesg - or 
> > was it worse?
> 
> I'm not sure about the real situation. I've heard this issue was found 
> in printing messages in NMI handler, maybe with artificial kernel stuck.

yeah, accidental NMI recursion back into printk could indeed cause the 
recursion message to pop up.

	Ingo
