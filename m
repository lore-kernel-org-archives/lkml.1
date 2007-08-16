Return-Path: <linux-kernel-owner+w=401wt.eu-S937680AbXHPBJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937680AbXHPBJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 21:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933790AbXHPBJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 21:09:41 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:22010 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932344AbXHPBJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 21:09:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=MDxeKS8Y538uty+wX4Xm3lukFIVmkfQspVLXzAphz+dhauOpjQqH2rZUNUQ4pj4Is8Ri3wq5mpQV0GrQCGM0LxxdNQFIRpzKDIHmgKUmLi/PPK4iDwnTRqzFu4BdljMcNctvo10AulISaDxgHdL+dxw4mHzODOvDjrS6kfYQoqs=  ;
X-YMail-OSG: PVJgBLwVM1l0oKODuvJgmuZ_XT_q3KaPH7v6IPcNalvUpBOij0qhZVkFZYyDtJrDXcMy50bcbA--
Message-ID: <46C3A3C5.5020103@yahoo.com.au>
Date: Thu, 16 Aug 2007 11:09:25 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Herbert Xu <herbert@gondor.apana.org.au>, csnook@redhat.com,
       dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
References: <20070811042943.GA13410@linux.vnet.ibm.com> <E1IKSHQ-0007hg-00@gondolin.me.apana.org.au> <20070813060302.GF13410@linux.vnet.ibm.com> <46C13EE1.1000707@yahoo.com.au> <20070814170128.GA8243@linux.vnet.ibm.com> <46C2FFDD.5000600@yahoo.com.au> <20070815201501.GM9645@linux.vnet.ibm.com>
In-Reply-To: <20070815201501.GM9645@linux.vnet.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Wed, Aug 15, 2007 at 11:30:05PM +1000, Nick Piggin wrote:

>>Especially since several big architectures don't have volatile in their
>>atomic_get and _set, I think it would be a step backwards to add them in
>>as a "just in case" thin now (unless there is a better reason).
> 
> 
> Good point, except that I would expect gcc's optimization to continue
> to improve.  I would like the kernel to be able to take advantage of
> improved optimization, which means that we are going to have to make
> a few changes.  Adding volatile to atomic_get() and atomic_set() is
> IMHO one of those changes.

What optimisations? gcc already does most of the things you need a
barrier/volatile for, like reordering non-dependant loads and stores,
and eliminating mem ops completely by caching in registers.


>>As to your followup question of why to use it over ACCESS_ONCE. I
>>guess, aside from consistency with the rest of the barrier APIs, you
>>can use it in other primitives when you don't actually know what the
>>caller is going to do or if it even will make an access. You could
>>also use it between calls to _other_ primitives, etc... it just
>>seems more flexible to me, but I haven't actually used such a thing
>>in real code...
>>
>>ACCESS_ONCE doesn't seem as descriptive. What it results in is the
>>memory location being loaded or stored (presumably once exactly),
>>but I think the more general underlying idea is a barrier point.
> 
> 
> OK, first, I am not arguing that ACCESS_ONCE() can replace all current
> uses of barrier().

OK. Well I also wasn't saying that ACCESS_ONCE should not be
implemented. But if we want something like it, then it would make
sense to have an equivalent barrier statement as well (ie. order()).

-- 
SUSE Labs, Novell Inc.
