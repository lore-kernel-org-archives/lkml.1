Return-Path: <linux-kernel-owner+w=401wt.eu-S1759057AbXHNFo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbXHNFo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942371AbXHNFnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:43:09 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:22286 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S942359AbXHNFnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:43:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=Lo5fIA4M379xA3p6GAYdItNhh7J68leRkrQ2f3HP3WRyAq6ukscs0ZUoEJHHsnrUCc9wT93jOMQvPA8ZifaaYd09zEjGdUlaLVYkiGkLlCkHTHj9TuaVHRY4zBNrk5ff4w+OJLDGVK/flMq9cT2ZKNCKeKAOjVdSO5PJ4wW8OpU=  ;
X-YMail-OSG: xDk6Wo4VM1mvtae8Jay_ezNKE9Q9EC1xTmUVuggd.3YIQ2tr4gJQ7qUQKAYvXQZNOeKfg5E9JA--
Message-ID: <46C140DD.3060509@yahoo.com.au>
Date: Tue, 14 Aug 2007 15:42:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Chris Snook <csnook@redhat.com>
CC: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       netdev@vger.kernel.org, akpm@linux-foundation.org, ak@suse.de,
       heiko.carstens@de.ibm.com, davem@davemloft.net, schwidefsky@de.ibm.com,
       wensong@linux-vs.org, horms@verge.net.au, wjiang@resilience.com,
       cfriesen@nortel.com, zlynx@acm.org, rpjday@mindspring.com,
       jesper.juhl@gmail.com
Subject: Re: [PATCH 6/24] make atomic_read() behave consistently on frv
References: <46BCC26B.6080600@redhat.com> <46BB46B2.60808@redhat.com> <20070809134150.GA14890@shell.boston.redhat.com> <2708.1186737826@redhat.com> <7680.1186822071@redhat.com> <46BFFDBD.6080804@redhat.com>
In-Reply-To: <46BFFDBD.6080804@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Snook wrote:
> David Howells wrote:
> 
>> Chris Snook <csnook@redhat.com> wrote:
>>
>>> cpu_relax() contains a barrier, so it should do the right thing.  For 
>>> non-smp
>>> architectures, I'm concerned about interacting with interrupt 
>>> handlers.  Some
>>> drivers do use atomic_* operations.
>>
>>
>> I'm not sure that actually answers my question.  Why not smp_rmb()?
>>
>> David
> 
> 
> I would assume because we want to waste time efficiently even on non-smp 
> architectures, rather than frying the CPU or draining the battery.  
> Certain looping execution patterns can cause the CPU to operate above 
> thermal design power.  I have fans on my workstation that only ever come 
> on when running LINPACK, and that's generally memory bandwidth-bound.  
> Just imagine what happens when you're executing the same few 
> non-serializing instructions in a tight loop without ever stalling on 
> memory fetches, or being scheduled out.
> 
> If there's another reason, I'd like to hear it too, because I'm just 
> guessing here.

Well if there is only one memory location involved, then smp_rmb() isn't
going to really do anything anyway, so it would be incorrect to use it.

Consider that smp_rmb basically will do anything from flushing the
pipeline to invalidating loads speculatively executed out of order. AFAIK
it will not control the visibility of stores coming from other CPUs (that
is up to the cache coherency).

-- 
SUSE Labs, Novell Inc.
