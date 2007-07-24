Return-Path: <linux-kernel-owner+w=401wt.eu-S936027AbXGXMBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936027AbXGXMBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760687AbXGXMBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:01:41 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:30085 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759343AbXGXMBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:01:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ORThIzNBCT8Q/Z6dKkb5EbS4sQAJHDHYpN3fwfYzC3gYSyeCvXIfR0j/KeU+4SUGmPLj9GxfWgGxV1MabYeM0d8PMcY477VwytuqOYoN4daW5aOg2tQKhPU6w2yHsBK/pcqpIv9Jzj9H9yPIJf6B2w/qqQwoS1rk+VKMLP9aGdE=  ;
X-YMail-OSG: f_gd6qgVM1lu4UmrEkxKr6hk4au8FiHZdieV9ggbknFgV33bsnavn4U6QGsmHo7k60N.qZMcqw--
Message-ID: <46A5EA1E.7000008@yahoo.com.au>
Date: Tue, 24 Jul 2007 22:01:34 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 8/8] i386: bitops: smp_mb__{before, after}_clear_bit()
 definitions
References: <423904.37199.qm@web53810.mail.re2.yahoo.com> <Pine.LNX.4.64.0707241631220.1433@cselinux1.cse.iitk.ac.in> <46A5E366.8030605@yahoo.com.au> <Pine.LNX.4.64.0707241708350.1433@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707241708350.1433@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On Tue, 24 Jul 2007, Nick Piggin wrote:

>>>>Are you saying that it is OK for the store to var to
>>>>be reordered below the clear_bit? If not, what are you
>>>>saying?
>>>
>>>
>>>I might be making a radical turn-around here, but all of a
>>>sudden I think it's actually a good idea to put a complete
>>>memory clobber in set_bit/clear_bit and friends themselves,
>>>and leave the "__" variants as they are.
>>
>>Why?
> 
> 
> Well, why not. Callers who don't want/need any guarantees whatsoever
> can still use __foo() -- for others, it makes sense to just use
> foo() and get *both* the compiler and CPU barrier semantics -- I think
> that's the behaviour most callers would want anyway.

Firstly, __foo() is non-atomic, secondly set_bit/clear_bit/etc do not
provide any CPU or compiler semantics.

It was set up this way because other CPU ISAs don't couple atomicity
with memory ordering, and with many implementations of those, the cost
to order memory is quite high.

-- 
SUSE Labs, Novell Inc.
