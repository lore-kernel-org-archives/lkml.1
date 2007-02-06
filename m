Return-Path: <linux-kernel-owner+w=401wt.eu-S1751760AbXBFI4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbXBFI4Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 03:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751770AbXBFI4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 03:56:16 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:25334 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751760AbXBFI4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 03:56:15 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=aj/eei/8slhZyljhVZFjhab4FKCZQZwBakvDmyK860wo9xMXeuGnqcvy2IdzdkeJ1T0MreJnK5kbf2zB8JBsAjOT4/kjSW45v8bSD4vN3/PnAEmgEEXSRP6aoVIxdjXMZmBsU4NB2Efr+ZwhIAjhlkl9P3EPRhs06F5LL/yNdvY=  ;
X-YMail-OSG: 6jtrdOsVM1nKymOOLVxjAWIJdDceSyeIjawvLvQa9wZ_H8CbMhOzcNJ6EVok9WPutIvGSkLz74_To2BIrhQA.i0gpHSwOw2fyF88efmveKkgZxCCn_i5RfLDzm3AMYR5FaIxc3GjQYWwZ.I-
Message-ID: <45C842A0.8010804@yahoo.com.au>
Date: Tue, 06 Feb 2007 19:56:00 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>
Subject: Re: [patch 3/3] mm: make read_cache_page synchronous
References: <20070206054925.21042.50546.sendpatchset@linux.site>	<20070206054957.21042.18724.sendpatchset@linux.site> <20070206002839.f02a47bc.akpm@linux-foundation.org>
In-Reply-To: <20070206002839.f02a47bc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue,  6 Feb 2007 09:02:33 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> 
> 
>>Ensure pages are uptodate after returning from read_cache_page, which allows
>>us to cut out most of the filesystem-internal PageUptodate_NoLock calls.
> 
> 
> Normally it's good to rename functions when we change their behaviour, but
> I guess any missed (or out-of-tree) filesystems will just end up doing a
> pointless wait_on_page_locked() and will continue to work OK, yes?

Yeah.

> 
> 
>>I didn't have a great look down the call chains, but this appears to fixes 7
>>possible use-before uptodate in hfs, 2 in hfsplus, 1 in jfs, a few in ecryptfs,
>>1 in jffs2, and a possible cleared data overwritten with readpage in block2mtd.
>>All depending on whether the filler is async and/or can return with a !uptodate
>>page.
>>
>>Also, a memory leak in sys_swapon().
> 
> 
> Separate patch?

Well its fixed by virtue of read_cache_page now correctly dropping the page
refcount if it finds the page !uptodate, rather than any special logic I
added.

I can do another patch though. No problem, I'll be resending the series after
this round of feedback.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
