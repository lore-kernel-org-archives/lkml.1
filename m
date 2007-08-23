Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbXHWGu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbXHWGu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 02:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751090AbXHWGuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 02:50:01 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:31114 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757221AbXHWGuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 02:50:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=yV2h9zbaySd3rLsSxkd8So7aV54d9Td4v/eYsjxqZt66K2TCR6l1GSKkwNXENxOJcI/O6XUCLyGZ4slxGWLRIp32C03D48yHh5Ld5U8oeg2N1kMHsgqYwLqLdM3JtLFRsPTBmkoEgmdqj5IiO6QxkhFniNCcqboY6rNsHrFloKE=  ;
X-YMail-OSG: N0NQdIQVM1lixweFRaP3Oo4GLEvdg8lN6WsqrOMpmvoRdD.iO9VeEEI9Q.2L8c2um6t6_6QbWA--
Message-ID: <46CD2E11.6080301@yahoo.com.au>
Date: Thu, 23 Aug 2007 16:49:53 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,RESEND] documentation: atomic_add_unless() doesn't imply
 mb() on failure
References: <20070817193453.GA198@tv-sign.ru>
In-Reply-To: <20070817193453.GA198@tv-sign.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> (the explicit ack/nack from maintainers is wanted).
> 
> A "typical" implementation of atomic_add_unless() can return 0 immediately
> after the first atomic_read() (before doing cmpxchg). In that case it doesn't
> provide any barrier semantics. See include/asm-ia64/atomic.h as an example.
> 
> We should either change the implementation, or fix the docs.

Did this end up getting merged? If not, it should, thanks.

Acked-by: Nick Piggin <npiggin@suse.de>

> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> 
>  Documentation/atomic_ops.txt      |    3 ++-
>  Documentation/memory-barriers.txt |    2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff -puN Documentation/atomic_ops.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure Documentation/atomic_ops.txt
> --- a/Documentation/atomic_ops.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure
> +++ a/Documentation/atomic_ops.txt
> @@ -137,7 +137,8 @@ If the atomic value v is not equal to u,
>  returns non zero. If v is equal to u then it returns zero. This is done as
>  an atomic operation.
>  
> -atomic_add_unless requires explicit memory barriers around the operation.
> +atomic_add_unless requires explicit memory barriers around the operation
> +unless it fails (returns 0).
>  
>  atomic_inc_not_zero, equivalent to atomic_add_unless(v, 1, 0)
>  
> diff -puN Documentation/memory-barriers.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure Documentation/memory-barriers.txt
> --- a/Documentation/memory-barriers.txt~doc-atomic_add_unless-doesnt-imply-mb-on-failure
> +++ a/Documentation/memory-barriers.txt
> @@ -1492,7 +1492,7 @@ about the state (old or new) implies an 
>  	atomic_dec_and_test();
>  	atomic_sub_and_test();
>  	atomic_add_negative();
> -	atomic_add_unless();
> +	atomic_add_unless();	/* when succeeds (returns 1) */
>  	test_and_set_bit();
>  	test_and_clear_bit();
>  	test_and_change_bit();
> _
> 
> 


-- 
SUSE Labs, Novell Inc.
