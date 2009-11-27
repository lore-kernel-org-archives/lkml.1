Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZK0Gbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZK0Gbf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751715AbZK0Gbe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:31:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:40358 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZK0Gbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:31:33 -0500
Message-ID: <4B0F7224.9020509@kernel.org>
Date: Fri, 27 Nov 2009 15:31:00 +0900
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
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <4B0D23A6.8040902@kernel.org> <20091125134058.GA9097@elte.hu> <200911270846.02717.rusty@rustcorp.com.au> <20091127054128.GC13914@elte.hu> <4B0F6A67.9010706@kernel.org> <20091127062001.GA22149@elte.hu>
In-Reply-To: <20091127062001.GA22149@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.
> At least to me a typo like this would stick out like a sore thumb during 
> review.

Yeah, maybe, but it still shows why reusing the same name for global
and local variables behind compiler's back is a bad idea.

> I'd recognize &reg1 as a stack local variable immediately, and when i 
> see it being used in this_cpu_inc() i'd go 'huh' immediately.
> 
> OTOH, the two examples of confusion i gave you in my previous mail would 
> be far less obvious. The 'visual distance' to a percpu variable 
> definition is greater (it's at least file scope in 95% of the cases), so 
> i wouldnt be able to 'see' which the percpu variables are, from a code 
> context.

With proper __percpu annotations (which we desparately need for
dynamic percpu pointers anyway) the 'visual distance' should remain
fine in most cases, I think.

If we can manage the separate namespace thing without adding confusion
regarding different types of accessors and the actually non-existing
but yet visible differences between static and dynamic percpu
variables, I think it would be good.  But it costs us quite a bit and
__percpu sparse annotation has almost complete coverage over the issue
including the visible queue telling that something is percpu.  So,
given that, to me __percpu seems like a much better way to do it.

Thanks.

-- 
tejun
