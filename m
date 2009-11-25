Return-Path: <linux-kernel-owner+w=401wt.eu-S934610AbZKYMlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934610AbZKYMlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 07:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934435AbZKYMly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 07:41:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:49693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934397AbZKYMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 07:41:54 -0500
Message-ID: <4B0D2585.90909@kernel.org>
Date: Wed, 25 Nov 2009 21:39:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: percpu tree build warning
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <20091125105004.GA18163@elte.hu> <200911252144.08686.rusty@rustcorp.com.au> <20091125115856.GA17856@elte.hu>
In-Reply-To: <20091125115856.GA17856@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/25/2009 08:58 PM, Ingo Molnar wrote:
> percpu variables are basically in a special struct. It's not like you 
> can _ever_ access 'dr7' the percpu variable like that - it _always_ has 
> to go via a proper percpu wrapper construct. So this change is 
> needlessly obtrusive.

The only problem is that now the addresses can and need be handled as
value.  If we keep the prefix, we just end up with one set of
accessors which prepend prefix to the symbol string and another set
which are basically the same but lack any protection (we already have
them - this_cpu accessors).  The current for-next tree is sort of
caught up inbetween.  Once sparse warning cleanup sweep is complete,
all static specific accessors will be dropped.

> Really, guys, while the workaround is easy (a rename), this might be 
> going a bit too far. I already think that the recently introduced 
> limitation to name local percpu symbols globally sucked - but i'm not 
> sure whether this new rule of not allowing such clear and clean looking 
> code is acceptable.
>
> Percpu variables now pollute _both_ the global and the local namespace - 
> i dont think you can have it both ways.

I agree static local symbol requiring global uniqueness truly sucks
but this is a completely different issue.  This is making percpu
variables behave more sanely and the fallouts are few and linux-next
warning check is enough to detect the few.

Thanks.

-- 
tejun
