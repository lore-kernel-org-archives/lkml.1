Return-Path: <linux-kernel-owner+w=401wt.eu-S1762299AbXH3Uz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762299AbXH3Uz7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 16:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbXH3Uzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 16:55:51 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:35150 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbXH3Uzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 16:55:50 -0400
Date: Thu, 30 Aug 2007 22:55:49 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Satyam Sharma <satyam@infradead.org>
cc: Alexey Dobriyan <adobriyan@gmail.com>, Joe Perches <joe@perches.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] trivial - constify sched.h
In-Reply-To: <alpine.LFD.0.999.0708310121121.28360@enigma.security.iitk.ac.in>
Message-ID: <Pine.LNX.4.64.0708302247070.10266@fbirervta.pbzchgretzou.qr>
References: <1188247231.18004.129.camel@localhost> <20070827213323.GA1759@martell.zuzino.mipt.ru>
 <Pine.LNX.4.64.0708302120290.24730@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0708310121121.28360@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 31 2007 02:11, Satyam Sharma wrote:
>> So that you can actually pass in a const struct task_struct * without having
>> to cast it back to [non-const].
>
>... which makes zero sense, because ...
>
>> Why one would have a const struct task_struct * in the first place
>> is a different matter.
>
>... exactly.
>
>> But see http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=77adbfbf4cf96fedf9b75bb330704828c187b190
>
>That commit const-ified struct timespec * or struct timeval * arguments,
>which made sense because: (1) those functions really did not modify the
>passed structs, and, (2) callers that pass in const struct timeval *
>or const struct timespec * are indeed plausible (because one can plausibly
>have const timeval/timespec structs). As the changelog suggested, those
>callers
>
>were having to cast away the const qualifier before passing to
>these functions to avoid seeing "passing argument discards qualifiers"
>warnings. While (1) holds true for the sched.h case here, (2) does not
>(and there are no warnings to shut up either).

"those callers". There was _exactly one_ caller, and that was an out-of-tree
module. There were not any in-kernel callers before, and it did not generate
any warning. That is perhaps why no one had constified it before me. This does
not mean we should wait for a caller to pop up before constifying IMHO.

>If one really wants to go about "constifying" the kernel, then I think
>there's a lot of _data_ out there that should first be made const-
>qualified. xxx_ops function tables, and the like.

I think it is equally 'necessary'.



	Jan
-- 
