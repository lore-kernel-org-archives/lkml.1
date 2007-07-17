Return-Path: <linux-kernel-owner+w=401wt.eu-S1762138AbXGQKIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762138AbXGQKIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 06:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbXGQKHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 06:07:54 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:58481 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbXGQKHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 06:07:52 -0400
Date: Tue, 17 Jul 2007 12:06:03 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Bodo Eggert <7eggert@gmx.de>, Ray Lee <ray-lk@madrabbit.org>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <469C0D32.2090102@gmail.com>
Message-ID: <Pine.LNX.4.58.0707171119050.2210@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
  <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> 
 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> 
 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> 
 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com>
 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
 <469BF768.6040200@gmail.com> <Pine.LNX.4.58.0707170143200.29868@be1.lrz>
 <469C0D32.2090102@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/LncFakmETQ8VgbHcA6AYz5J8GwJMObVfYxn/
 tYSVGrpr7mKCKEinZzeYVK4Ea8SWeJlZaygO2Z9fdYSsBDcITL
 RaBidooxaHzZEGT0YNqBA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Rene Herman wrote:
> On 07/17/2007 01:45 AM, Bodo Eggert wrote:
> > On Tue, 17 Jul 2007, Rene Herman wrote:
> >> On 07/17/2007 12:37 AM, Ray Lee wrote:

> >>> If at some point one of the pro-4k stacks crowd can prove that all 
> >>> code paths are safe
> >> I'll do that the minute you prove the current shared 8K stacks are
> >> safe. Do we have a deal?
> > 
> > You claim 4k+4k is safe, therefore 8k must be safe, too.
> 
> No, I most certainly do not. I claim proving that 4K and seperate (per cpu) 
> interrupt stacks are safe are exactly the same as proving unshared 8K stacks 
> are safe. That is, you don't, no such proof exists other than in the eating 
> of the pudding.

And yet you have a more strict claim than I do. If you are right, I'll be
right, too, because two times less-than-4K is less tham 8K. If I'm wrong
and 8K is not enough, you must be wrong, too, because you can impossibly
fit more than 8K into 4K+4K. That's the law of mathematics.

> Ray (and you) in considering !CONFIG_4KSTACKS to be "safer" 
> than CONFIG_4KSTACKS suggest that _inevitably_ CONFIG_4KSTACKS would leave 
> you with less available stack and I pointed out this isn't be the case.

Why do you insist on 4Kstacks being good as long as there is _one_ usevase 
not crashing the kernel? _All_ usecases have to be safe!

> And in fact, I shouldn't have said "exactly" the same. Unshared interrupt 
> stacks

, which are a completely different thing which was bundled to 4K-stacks
  because you need more than 4K,

> make for more determistisc behaviour, so you'd have a harder time 
> proven anything to some set limit of uncertainty with the shared 8K stacks 
> than with the unshared 4K stacks.

I don't want my stack to overflow in order to be theoretically able to
prove it does not overflow. I'd rather go for 8K+4K-stacks, and if _you_
have done the proof _you_ wanted to make, we can talk again about
4K-stacks. Then I'll just add up the maximum stack usages and have the
proof that 8K stacks are safe.

> > But if 8k is safe, this does not yet prove that you can store 5k+3k in
> > 4k+4k.
> 
> I really have not made any claim of the kind. The argument is that with 
> CONFIG_4KSTACKS, availeble stack space isn't inevitably less at any point in 
> time.

I claim, you can store 5k + 3k on the 8k stack, where 5k is something like
the current worst case for non-interrupt stack and 3k is plenty for
interrupts. Thousands of stable systems with 8K stacks support my claim.

You claimed with 4k + 4k, there is not less available stack space.
(At least for usecases you are interested in, but I'll asume you don't 
 want other usecases to crash.)

If you were right, I'd have enough space on 4k + 4k to store that 5k.
Obviously, thousands of systems disagree by crashing with 4K-stacks.
That's most simple logic.

Off cause I may be wrong and the kernels don't crash because of 4K stacks, 
but because of bad karma ... But even then, you'd first have to get rid of
that bad karma before defaulting to 4K stacks.

-- 
Top 100 things you don't want the sysadmin to say:
41. OH, SH*T! (as they scrabble at the keyboard for ^c).
