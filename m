Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbXHQDce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbXHQDce (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 23:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752665AbXHQDcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 23:32:23 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:21223 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752424AbXHQDcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 23:32:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=A6fo5a611CRYXx5IsekLpCXrSFf7Aachil34/I/WKo1WDEfZQyk4cXnhHsabHuBvW5+HapQYVuyKcbUtThxOqVBIySWatg4OuQenpZ/ttOnkcDB0F+nGquxWRYjb+7v07THsOMbdvV74qM0vFi2XWgGcDtOVK4PD8N/7TJTLwzI=  ;
X-YMail-OSG: D2BdBd4VM1kYFBlMm2PI6DLR2kV3bCPrQQnA4c3_ntA6VnNwEmsZIatxxLjJbtxxFuUtY9yyIw--
Message-ID: <46C516BA.60700@yahoo.com.au>
Date: Fri, 17 Aug 2007 13:32:10 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Segher Boessenkool <segher@kernel.crashing.org>, heiko.carstens@de.ibm.com,
       horms@verge.net.au, linux-kernel@vger.kernel.org, rpjday@mindspring.com,
       ak@suse.de, netdev@vger.kernel.org, cfriesen@nortel.com,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       jesper.juhl@gmail.com, linux-arch@vger.kernel.org, zlynx@acm.org,
       satyam@infradead.org, clameter@sgi.com, schwidefsky@de.ibm.com,
       Chris Snook <csnook@redhat.com>, Herbert Xu <herbert.xu@redhat.com>,
       davem@davemloft.net, wensong@linux-vs.org, wjiang@resilience.com
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
References: <E1ILCgh-00052A-00@gondolin.me.apana.org.au>	<46C32618.2080108@redhat.com>	<20070815234021.GA28775@gondor.apana.org.au>	<3694fb2e4ed1e4d9bf873c0d050c911e@kernel.crashing.org>	<46C3B50E.7010702@yahoo.com.au>	<194369f4c96ea0e24decf8f9197d5bad@kernel.crashing.org>	<46C505B2.6030704@yahoo.com.au> <18117.4848.695269.72976@cargo.ozlabs.ibm.com>
In-Reply-To: <18117.4848.695269.72976@cargo.ozlabs.ibm.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Nick Piggin writes:
> 
> 
>>So i386 and x86-64 don't have volatiles there, and it saves them a
>>few K of kernel text. What you need to justify is why it is a good
> 
> 
> I'm really surprised it's as much as a few K.  I tried it on powerpc
> and it only saved 40 bytes (10 instructions) for a G5 config.
> 
> Paul.
> 

I'm surprised too. Numbers were from the "...use asm() like the other
atomic operations already do" thread. According to them,

   text    data     bss     dec     hex filename
3434150  249176  176128 3859454  3ae3fe atomic_normal/vmlinux
3436203  249176  176128 3861507  3aec03 atomic_volatile/vmlinux

The first one is a stock kenel, the second is with atomic_read/set
cast to volatile. gcc-4.1 -- maybe if you have an earlier gcc it
won't optimise as much?

-- 
SUSE Labs, Novell Inc.
