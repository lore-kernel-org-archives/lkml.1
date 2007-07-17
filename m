Return-Path: <linux-kernel-owner+w=401wt.eu-S1765445AbXGQOjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765445AbXGQOjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbXGQOj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:39:26 -0400
Received: from smtpq3.tilbu1.nb.home.nl ([213.51.146.202]:36070 "EHLO
	smtpq3.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbXGQOjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:39:25 -0400
Message-ID: <469CD456.801@gmail.com>
Date: Tue, 17 Jul 2007 16:38:14 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: Ray Lee <ray-lk@madrabbit.org>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
References: <8FO1e-2jW-35@gated-at.bofh.it> <8Ghmx-60z-17@gated-at.bofh.it>  <8Gj55-hJ-5@gated-at.bofh.it> <8GkNo-2Vb-1@gated-at.bofh.it>  <8GtnN-7TG-23@gated-at.bofh.it> <8GVjY-PL-25@gated-at.bofh.it>  <E1IA7j1-0000j9-I3@be1.lrz> <469A5D7C.5010904@gmail.com>  <Pine.LNX.4.58.0707161523500.25779@be1.lrz>  <469BF104.1040703@gmail.com> <2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com> <469BF768.6040200@gmail.com> <Pine.LNX.4.58.0707170143200.29868@be1.lrz> <469C0D32.2090102@gmail.com> <Pine.LNX.4.58.0707171119050.2210@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707171119050.2210@be1.lrz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2007 12:06 PM, Bodo Eggert wrote:

> On Tue, 17 Jul 2007, Rene Herman wrote:
>> On 07/17/2007 01:45 AM, Bodo Eggert wrote:

>>> You claim 4k+4k is safe, therefore 8k must be safe, too.
>> 
>> No, I most certainly do not. I claim proving that 4K and seperate (per cpu) 
>> interrupt stacks are safe are exactly the same as proving unshared 8K stacks 
>> are safe. That is, you don't, no such proof exists other than in the eating 
>> of the pudding.
> 
> And yet you have a more strict claim than I do. If you are right, I'll be
> right, too, because two times less-than-4K is less tham 8K.

Firstly, it's not two times 4K but 4K + (4K + 4K) * NR_CPUS. Secondly, _you_ 
are the one making claims -- specifically that !CONFIG_4KSTACKS is "safer", 
happily ignoring the fact that generally speaking available process stack 
can be _better_ with CONFIG_4KSTACKS and there seems to exist but _one_ 
(één, ein, une) known situation where it's problematic.

Must there be none rather than one? In some senses maybe, if the problem is 
more than bad, fixable code but I doubt you know this. CONFIG_4KSTACKS is 
much better on the VM (and hence faster) and as such, any user not using the 
one nicely isolated and identified problem case benefits from it. This means 
it's either very close or already _at_ the point of being the best default 
for the kernel. Changing options is for users with special needs, as you 
believe you are.

I truly apologise for taking it into this direction but you're wearing me 
down rapidly. Every single time you insert some uninformed crap comment that 
shows that you both don't understand the issue and didn't understand what 
the other person was saying and then after being made aware of such, ignore 
that and follow up with the next uninformed crap comment. That is, you seem 
to care less about the issue then about the discussion and since for me it's 
quite the other way around I'm leaving it at that.

RedHat is the one with the actual data available, and they've been enabling 
4KSTACKS for quite some time now (with some of their users apparently 
unhappy about it but not many it would seem).

Jesper also already posted how he's going to proceed: lift 4K from debug 
status and submit it as default for -mm. As to the latter bit, unless I 
remember wrong, it already _was_ default in -mm for some time a while ago so 
Andrew no doubt has an informed opinion on how to proceed with that.

Rene.
