Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYFSUcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYFSUcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 16:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750931AbYFSUcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 16:32:00 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:58406 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYFSUb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 16:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VZlkXmZsp1KaBvtLir+BZLXdC7JJ+rDKmreZmh0MS6WIYr6MS6Zto3kLTG2Md0oKik
         9T4LsCNmUiXbl2qmMY7R08UcT4dy3zQM+h5s7oxI2jqqb/hobzAt+37pnOUfFEr0frq4
         VhttWs39UdHDZVVn3X5hJvF1LbzBcCMQnKCgg=
Message-ID: <48f7fe350806191331h69ed1418v76d74c4315896192@mail.gmail.com>
Date: Thu, 19 Jun 2008 16:31:55 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: [BUG] Lockless patches cause hardlock under heavy IO
Cc: "Peter Zijlstra" <peterz@infradead.org>, linux-mm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200806191819.31968.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350806181415l4eba61b3i1d206de03147575e@mail.gmail.com>
	 <1213863122.16944.257.camel@twins>
	 <200806191819.31968.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be hardlocking on anyone that has a 64bit processor, the
only one who this has not locked on yet has a 32bit processor. I hope
that helps, its the best I can come up with so far.

-Ryan

On Thu, Jun 19, 2008 at 4:19 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 19 June 2008 18:12, Peter Zijlstra wrote:
>> On Wed, 2008-06-18 at 17:15 -0400, Ryan Hope wrote:
>> > I applied the following patches from 2.6-26-rc5-mm3 to 2.6.26-rc6 and
>> > they caused a hardlock under heavy IO:
>>
>> What kind of machine, how much memory, how many spindles, what
>> filesystem and what is heavy load?
>>
>> Furthermore, try the NMI watchdog with serial/net-console to capture its
>> output.
>
>
> Good suggestions. A trace would be really helpful.
>
> As Arjan suggested, debug options especially CONFIG_DEBUG_VM would be
> a good idea to turn on if you haven't already.
>
> BTW. what was the reason for applying those patches? Did you hit the
> problem with -mm also, and hope to narrow it down?
>
>
>> > x86-implement-pte_special.patch
>> > mm-introduce-get_user_pages_fast.patch
>> > mm-introduce-get_user_pages_fast-fix.patch
>> > mm-introduce-get_user_pages_fast-checkpatch-fixes.patch
>> > x86-lockless-get_user_pages_fast.patch
>> > x86-lockless-get_user_pages_fast-checkpatch-fixes.patch
>> > x86-lockless-get_user_pages_fast-fix.patch
>> > x86-lockless-get_user_pages_fast-fix-2.patch
>> > x86-lockless-get_user_pages_fast-fix-2-fix-fix.patch
>> > x86-lockless-get_user_pages_fast-fix-warning.patch
>> > dio-use-get_user_pages_fast.patch
>> > splice-use-get_user_pages_fast.patch
>> > x86-support-1gb-hugepages-with-get_user_pages_lockless.patch
>> > #
>> > mm-readahead-scan-lockless.patch
>> > radix-tree-add-gang_lookup_slot-gang_lookup_slot_tag.patch
>> > #mm-speculative-page-references.patch: clameter saw bustage
>> > mm-speculative-page-references.patch
>> > mm-speculative-page-references-fix.patch
>> > mm-speculative-page-references-fix-fix.patch
>> > mm-speculative-page-references-hugh-fix3.patch
>> > mm-lockless-pagecache.patch
>> > mm-spinlock-tree_lock.patch
>> > powerpc-implement-pte_special.patch
>> >
>> > I am on an x86_64. I dont know what other info you need...
>
> Can you isolate it to one of the two groups of patches? I suspect it
> might be the latter so you might try that first -- this version of
> speculative page references is very nice in theory but it is a little
> more complex to implement the slowpaths so it could be an error there.
>
