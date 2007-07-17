Return-Path: <linux-kernel-owner+w=401wt.eu-S936858AbXGQXUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936858AbXGQXUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 19:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936632AbXGQXTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 19:19:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:65193 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936624AbXGQXTj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 19:19:39 -0400
Date: Wed, 18 Jul 2007 01:19:16 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
cc: Bodo Eggert <7eggert@gmx.de>, Ray Lee <ray-lk@madrabbit.org>,
       Matt Mackall <mpm@selenic.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <469CD456.801@gmail.com>
Message-ID: <Pine.LNX.4.58.0707172334210.2141@be1.lrz>
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>
  <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it> 
 <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it> 
 <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com> 
 <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com>
 <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
 <469BF768.6040200@gmail.com> <Pine.LNX.4.58.0707170143200.29868@be1.lrz>
 <469C0D32.2090102@gmail.com> <Pine.LNX.4.58.0707171119050.2210@be1.lrz>
 <469CD456.801@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX195qX9FY75uLZF6qBpuRIMDok7cx+uv5y+MliZ
 4WXFhN2E1unRPjESw4Xq/zofaTD3hQFzhrP2BKY34TOadM8kdq
 QNc8gjsPo5L1VYcXy6PWw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007, Rene Herman wrote:
> On 07/17/2007 12:06 PM, Bodo Eggert wrote:
> > On Tue, 17 Jul 2007, Rene Herman wrote:
> >> On 07/17/2007 01:45 AM, Bodo Eggert wrote:

> >>> You claim 4k+4k is safe, therefore 8k must be safe, too.
> >> 
> >> No, I most certainly do not. I claim proving that 4K and seperate (per cpu) 
> >> interrupt stacks are safe are exactly the same as proving unshared 8K stacks 
> >> are safe. That is, you don't, no such proof exists other than in the eating 
> >> of the pudding.
> > 
> > And yet you have a more strict claim than I do. If you are right, I'll be
> > right, too, because two times less-than-4K is less tham 8K.
> 
> Firstly, it's not two times 4K but 4K + (4K + 4K) * NR_CPUS. Secondly, _you_ 
> are the one making claims -- specifically that !CONFIG_4KSTACKS is "safer", 
> happily ignoring the fact that generally speaking available process stack 
> can be _better_ with CONFIG_4KSTACKS

It can be better, but the worst case stays 4K + 4K - unless one CPU will 
walk over to the next and nicely ask for a cup of stack.

Therefore you can discuss 4K + 4K or 4K + 4K + 4K, or 4K + 4K * \inf. It 
won't change a thing:

1) It all can be reduced to 4K + 4K by asuming all IRQ happen on one CPU.
2) Even if the interrupts decide not to happen on one CPU, you still can't 
   fit that possible 5K into 4K.

Having a local stack per CPU helps locality, and it's gootd, but that's 
about it.

> and there seems to exist but _one_ 
> (één, ein, une) known situation where it's problematic.

One case is reason enough not to enable 4K-stacks per default, and this 
is a common server setup. "server" as in "I need a reliable system".

> Must there be none rather than one? In some senses maybe, if the problem is 
> more than bad, fixable code but I doubt you know this. CONFIG_4KSTACKS is 
> much better on the VM (and hence faster) and as such,

"Look how fast I crashed!" doesn't buy you anything. In order to finish 
first, you first got to finish.

> any user not using the 
> one nicely isolated and identified problem case benefits from it.

And they can turn it on.

> This means 
> it's either very close or already _at_ the point of being the best default 
> for the kernel. Changing options is for users with special needs, as you 
> believe you are.

If you designed a car, you would also go for breaks with a well-known 
problem just because they weight less and all that people not crossing 
mountains would be happy about the weight benefit - that is if they'd 
notice, wouldn't you?

Please post a list of things you have designed, so I can avoid them.

> I truly apologise for taking it into this direction but you're wearing me 
> down rapidly.

I put the facts onto the ground. If you're getting down, you may stumble 
on them. Beware

> Every single time you insert some uninformed crap comment that 
> shows that you both don't understand the issue and didn't understand what 
> the other person was saying and then after being made aware of such, ignore 
> that and follow up with the next uninformed crap comment.

So what did you say about the worst case stack size being bigger than 4K?
That's correct, you choose to put it aside as a minor use case. Yea, it's
just the combination you'd choose for a reliable server setup, the users
won't have a problem when their systems crash ...

Was your claim about each CPU having a separate stack helping your cause?
No, everybody can see it's not. That is, except for you, your CPU will
just borrow some, since their neighbours have some free stack.


But let's not stop here: You claimed: "Unshared interrupt 
stacks make for more determistisc behaviour, so you'd have a harder time 
proven anything to some set limit of uncertainty with the shared 8K stacks 
than with the unshared 4K stacks."

So you want to tell me I can't prove 8K stacks are safe - you are right.
But can you prove 4K stacks are safe? You can't either. But you want to be
able to prove it. I told you to stick to your words - go and prove 4K+4K
to be safe. What did you do? You chose to ignore that.

I bet you don't even consider proving 4K stacks to be correct, nor do you
know anyone who would try that in the near future. And besides that, you
know at least one case where your proof would fail. So why would you talk
about proofs? Do you think you can trick me into believing a crashing 
system would work more correctly than a non-crashing one, just by 
mentioning the possibility of having it easier to make a proof?


Besides that, I told you you can separate unshared interrupt stacks from 
4K stacks. And yet, you still argue as if 4K stacks are required for 
having a separate interrupt stack.


So who's ignoring facts, who is talking crap?

> That is, you seem 
> to care less about the issue then about the discussion and since for me it's 
> quite the other way around I'm leaving it at that.

I know very well you're going to turn linux into a bleeding edge system 
where you're supposed to get some bad surprises on an update, unless you 
happen not to hit the error case. That's not the way I'd like it to go.
You may use -mm, you'll get the 4K stacks per default, be happy wih them.

> RedHat is the one with the actual data available, and they've been enabling 
> 4KSTACKS for quite some time now (with some of their users apparently 
> unhappy about it but not many it would seem).

Would you use a distribution crashing on your servers? Or would you change
the distribution and spread the word not to use redhat?

-- 
"'Multiple exclamation marks,' he went on, shaking his head, 'are a 
sure sign of a diseased mind.'"
	-- Terry Pratchett in "Eric"
