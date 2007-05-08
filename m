Return-Path: <linux-kernel-owner+w=401wt.eu-S967863AbXEHXYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967863AbXEHXYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967376AbXEHXYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:24:10 -0400
Received: from smtp101.mail.mud.yahoo.com ([209.191.85.211]:37600 "HELO
	smtp101.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S967364AbXEHXYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:24:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=nj35IiLBKGgSurqmF41LElfZg2irQh5mSPIT5Y1npnzlsGsS8639+Gs2VRHVGQS9svIhjZnMU1SsKX2YjJManrlsap467BRWgOmdQ9ZhT5vKxOadbDbBSKhtYNsOm4ZMsZUzBQSgR7dgqCpEGPphUg75kSHpxevKnuX9slZSsu8=  ;
X-YMail-OSG: zEblq_gVM1n4qhPfF4BbTasGyvzsoNAtdSFL.jTaMOco0TpZRrZdZEowzqJ84YWZIhB1o91fSA--
Message-ID: <4641065D.6060403@yahoo.com.au>
Date: Wed, 09 May 2007 09:23:09 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au> <463B598B.80200@redhat.com> <463BC62C.3060605@yahoo.com.au> <463E5A00.6070708@redhat.com> <464014B0.7060308@yahoo.com.au> <4640906B.2020301@redhat.com>
In-Reply-To: <4640906B.2020301@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> Nick Piggin wrote:
> 
>> We have percpu and cache affine page allocators, so when
>> userspace just frees a page, it is likely to be cache hot, so
>> we want to free it up so it can be reused by this CPU ASAP.
>> Likewise, when we newly allocate a page, we want it to be one
>> that is cache hot on this CPU.
> 
> 
> Actually, isn't the clear page function capable of doing
> some magic, when it writes all zeroes into the page, that
> causes the zeroes to just live in CPU cache without the old
> data ever being loaded from RAM?
> 
> That would sure be faster than touching RAM.  Not sure if
> we use/trigger that kind of magic, though :)
> 

powerpc has and uses an instruction to zero a full cacheline, yes.

Not sure about x86-64 CPUs... I don't think they can do it.

-- 
SUSE Labs, Novell Inc.
