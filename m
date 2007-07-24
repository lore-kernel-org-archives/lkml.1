Return-Path: <linux-kernel-owner+w=401wt.eu-S933119AbXGXHQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933119AbXGXHQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 03:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759319AbXGXHQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 03:16:45 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:37439 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758234AbXGXHQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 03:16:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=SPs7mfquNA5uJtdepztZOPT35Wo3yIcl2pOfCyfuchAzhUCbQsp3F6TzAeo3uaXw6aIfpt3j/1wJ8YIAaAXtRzkg5oZcIxghbi1dDuhDwVSrbcf2RKssCR4jx0o0p40M7hsG6sxFqjxqdsUww3VZMRq+9BXxFTSy6y7pmrPwz2c=  ;
X-YMail-OSG: tiEjY.AVM1n6HaFwFrEoqeqoBKZEJYXmfS7kKnIJIb62ljMa_B2ALCZb8D9bszPXhReLjlWzyA--
Message-ID: <46A5A756.8040008@yahoo.com.au>
Date: Tue, 24 Jul 2007 17:16:38 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/8] i386: bitops: Kill volatile-casting of memory addresses
References: <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160548.22137.66072.sendpatchset@cselinux1.cse.iitk.ac.in> <alpine.LFD.0.999.0707231046140.3607@woody.linux-foundation.org> <46A57DCB.7050609@yahoo.com.au> <Pine.LNX.4.64.0707241115120.1433@cselinux1.cse.iitk.ac.in>
In-Reply-To: <Pine.LNX.4.64.0707241115120.1433@cselinux1.cse.iitk.ac.in>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> On Tue, 24 Jul 2007, Nick Piggin wrote:
> 
> 
>>Linus Torvalds wrote:
>>

>>>Of course, if we remove all "volatiles" in data in the kernel (with the
>>>possible exception of "jiffies"), we can then remove them from function
>>>declarations too, but it should be done in that order.
>>
>>Well, regardless, it still forces the function to treat the pointer
>>target as volatile, won't it? It definitely prevents valid optimisations
>>that would be useful for me in mm/page_alloc.c where page flags are
>>being set up or torn down or checked with non-atomic bitops.
> 
> 
> Yes, and yes. But I think what he meant there is that we'd need to
> audit the kernel for all users of set_bit and friends and see if callers
> actually pass in any _data_ that _is_ volatile. So we have to kill them
> there first, and then in the function declarations here. I think I'll put
> that on my long-term todo list, but see below.

Yeah that is probably what he meant.


>>Anyway by type safety, do you mean it will stop the compiler from
>>warning if a pointer to a volatile is passed to the bitop?
> 
> 
> The compiler would start warning for all those cases (passing in
> a pointer to volatile data, when the bitops have lost the volatile
> casting from their function declarations), actually. Something like
> "passing argument discards qualifiers from pointer type" ... but
> considering I didn't see *any* of those warnings after these patches,
> I'm confused as to what exactly Linus meant here ... and what exactly
> do we need to do "kill the volatiles".

Because even with an allyesconfig, your compile isn't testing the
entire kernel. So given the relatively minor benefit of removing
the volatiles, I suppose we shouldn't risk slipping a bug in. If
you can make gcc throw an error in that case it would be a different
story.

-- 
SUSE Labs, Novell Inc.
