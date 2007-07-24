Return-Path: <linux-kernel-owner+w=401wt.eu-S932686AbXGXD5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686AbXGXD5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 23:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755830AbXGXD51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 23:57:27 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:44323 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751021AbXGXD50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 23:57:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=hxTf6A8t1c6RhSjnkvZHizncwuo29cLdsHIfdUMR+ZJk526t54SW5dNKeGurrS3/yGBuj7lXiub4BKGKiNb2B9JDWqj3o0wRuhOcHY4hA+iET0UmxLzeo78z3kcASmtIOg1uEJcj+k1btiKB5qgmzeqnyy7JqvfneUAxwzagmuY=  ;
X-YMail-OSG: YLag1OoVM1k4q3XJuZXrzf6Q9WAJrX2PgJTR6Zwfh6sGbXlqX_wGHeRMt9IrJkZsFCekjDH1MA--
Message-ID: <46A578A1.5010504@yahoo.com.au>
Date: Tue, 24 Jul 2007 13:57:21 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
In-Reply-To: <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
> 
> [6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
> 
> The goal is to let gcc generate good, beautiful, optimized code.
> 
> But test_and_set_bit, test_and_clear_bit, __test_and_change_bit,
> and test_and_change_bit unnecessarily mark all of memory as clobbered,
> thereby preventing gcc from doing perfectly valid optimizations.
> 
> The case of __test_and_change_bit() is particularly surprising, given
> that it's a variant where we don't make any guarantees at all.

__test_and_change_bit is one that you could remove the memory clobber
from.

> ---
> 
>  include/asm-i386/bitops.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/asm-i386/bitops.h b/include/asm-i386/bitops.h
> index 0f5634b..f37b8a2 100644
> --- a/include/asm-i386/bitops.h
> +++ b/include/asm-i386/bitops.h
> @@ -254,7 +254,7 @@ static inline int __test_and_change_bit(int nr, unsigned long *addr)
>  	__asm__ __volatile__(
>  		"btcl %2,%1\n\tsbbl %0,%0"
>  		:"=r" (oldbit),"=m" (*addr)
> -		:"r" (nr) : "memory");
> +		:"r" (nr));
>  	return oldbit;
>  }
>  


-- 
SUSE Labs, Novell Inc.
