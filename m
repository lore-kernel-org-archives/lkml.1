Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZDKByn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZDKByn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 21:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752272AbZDKBy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 21:54:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:47965 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754826AbZDKByZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 21:54:25 -0400
Message-ID: <49DFF7EA.900@kernel.org>
Date: Fri, 10 Apr 2009 18:52:42 -0700
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <49D3231D.2040403@kernel.org> <20090409094713.GA6538@jurassic.park.msu.ru> <49DDE1B5.4070407@kernel.org> <200904111108.08323.rusty@rustcorp.com.au>
In-Reply-To: <200904111108.08323.rusty@rustcorp.com.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 11 Apr 2009 01:52:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Thu, 9 Apr 2009 09:23:25 pm Tejun Heo wrote:
>> It's generally a good idea to use uniquely
>> distinguisible identifier for static symbols anyway to help debugging.
> 
> Sorry, I can't let this statement stand.  It's completely wrong: use the
> shortest clear name, always.

Heh... well, yeah, I don't think this is something everyone can agree
about.  I generally like having proper prefix for static symbols.  It
makes symbols more consistent too.

>> If this limitation is acceptable, I think we should also add the dup
>> build failure thing to the generic definition too tho so that such
>> cases can be discovered before they hit alpha and s390 later.
>>
>> Any objections?
> 
> Yes.  If we decide that static per-cpu is unsupportable, let's not
> hide the damn thing.  We just make it give a compile warning if we
> can, patch out the current cases, and make checkpatch.pl warn on new
> ones.
> 
> Don't silently override "static".  Don't come up with stupid
> justifications.  Accept with open-eyes that it's evil, just a lesser
> evil.

It's different tho.  With the right tricks, we can still make percpu
variables defined static unusable from other compile units.  ie. if we
make the combination of DECLARE_PER_CPU() and static DEFINE_PER_CPU()
trigger compile error, most of what the programmer meant by 'static'
can be achieved whether the symbol itself ends up visible outside of
the compile unit or not.

Thanks.

-- 
tejun
