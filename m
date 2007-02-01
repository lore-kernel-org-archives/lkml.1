Return-Path: <linux-kernel-owner+w=401wt.eu-S1161129AbXBAAox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161129AbXBAAox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:44:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161131AbXBAAox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:44:53 -0500
Received: from smtp102.mail.mud.yahoo.com ([209.191.85.212]:35044 "HELO
	smtp102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161129AbXBAAow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:44:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=FPVkleb3cwzmxVv3lMeXzUUv85w/cDtaZkALipJZOay/LYt/fnQJjY3mkh7QPTNNvgAY3kZ7/0W+upR1Hb/xbt/5cNPzUEJ92mIwFRfAhRmHNQBoIZ5XDY17bqVbdxhAxGFsn6aDfNj1aBABIC2wyq8cNEgpik1qbAvmOJ5hais=  ;
X-YMail-OSG: oPsYHhYVM1lTlFs9I7Duy_ldfFm3BFrwkQ4Nz.sbF4vf5jy8ydeq.a8r4KUaHsDjBCcs5rOSyffrER8CQiKMRvWdxs5BmLNTTmbWJkfZVhhgEUS6USdgKSM7wMBU0js4_Uv5vv1e9lUuFahenptskBlwM3z809QFRW5Ka_qLBNqICCZryhDCFi3Jn5m6
Message-ID: <45C137F4.90303@yahoo.com.au>
Date: Thu, 01 Feb 2007 11:44:36 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?ISO-8859-1?Q?Pawe=C5_Sikora?= <pluto@agmk.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@lst.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Martin Peschke <mp3@de.ibm.com>, Andrew Morton <akpm@osdl.org>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.20-rc7
References: <Pine.LNX.4.64.0701302019530.11095@woody.linux-foundation.org> <45C05150.6000802@agmk.net> <Pine.LNX.4.64.0701310748450.3632@woody.linux-foundation.org> <200702010037.48472.pluto@agmk.net> <Pine.LNX.4.64.0701311609210.3632@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0701311609210.3632@woody.linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> 	if (free_pages <= min + z->lowmem_reserve[classzone_idx])
> 		return 0;
> 
> gets broken, because the negative 'free_pages' will look like a huge 
> unsigned positive number (and we'll make it unsigned becaue 'min' got 
> turned unsigned). There was a reason that thing was signed in the first 
> place, and neither me nor Andrew noticed.
> 
> Bad Nick. And bad me and Andrew for not noticing.

Sorry. I think I even wrote that comment at the top of the function.
And probably the function as well :(

> I should either revert that commit or just check for "free_pages" being 
> negative. The latter, in many ways, is probably better, because generally 
> we simply should never work with negative numbers in the kernel, so when 
> something potentially goes negative, we're probably just better off always 
> testing it explicitly anyway.
> 
> Nick, Andrew, any preferences? 

As Andrew says, it would need to be checked each time, because we have
nothing synchronising against free_pages at the top, or nr_free in the
loop.

We could make them both unsigned, and _add_ everything to min rather than
subtracting from free_pages?

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
