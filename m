Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbYFSOwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbYFSOwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 10:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750820AbYFSOwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 10:52:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:28558 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYFSOwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 10:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=G+VkSQOIg/Afcs+a5wYrBUn2gHXhIP4/Nk6kTR9hl6q3y3tXShwSLDlSVPsaEekN1h
         NF0zAPziR55AX6V1DzPxKtE/VMNWgUnSmj3paXwMpFv0Yaeaz7skE2218bJdRPLHVgAA
         RqQuJq/bKFkj+kKDziuu3yJp3l8MNTTPnrS24=
Message-ID: <48f7fe350806190752h5bde0c80mb048d2456bd65be2@mail.gmail.com>
Date: Thu, 19 Jun 2008 10:52:38 -0400
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

The reason for applying these patches was because users of my patchset
have been wanting me to include lockless again. It was pretty popular
among the users but we removed it because it would cause hardlocks. I
though I would try it out again now that its in -mm.

I guess I could start reverting patches and see if the issue goes away.

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
