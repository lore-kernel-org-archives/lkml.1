Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753280AbYLRNXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbYLRNXw (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 08:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYLRNXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 08:23:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbYLRNXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 08:23:42 -0500
Date: Thu, 18 Dec 2008 14:23:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com,
        joerg.roedel@amd.com
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
	of swiotlb
Message-ID: <20081218132313.GE32135@elte.hu>
References: <20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp> <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp> <49494BE4.1070408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49494BE4.1070408@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> FUJITA Tomonori wrote:
>> On Wed, 17 Dec 2008 08:31:43 -0800
>> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>   
>>>> I think that the whole patchset is against the swiotlb design. swiotlb
>>>> is designed to be used as a library. Each architecture implements the
>>>> own swiotlb by using swiotlb library
>>>> (e.g. arch/x86/kernel/pci-swiotlb_64.c).
>>>>         
>>> The whole patchset?  The bulk of the changes to lib/swiotlb.c are  
>>> relatively minor to remove the unwarranted assumptions it is making 
>>> in the face of a new user.  They will have no effect on other 
>>> existing users, including non-Xen x86 builds.
>>>
>>> If you have specific objections we can discuss those, but I don't 
>>> think there's anything fundamentally wrong with making lib/swiotlb.c 
>>> a bit more generically useful.
>>>     
>>
>> Sorry, but the highmem support is not generically useful.
>>   
>
> That's a circular argument.  lib/swiotlb currently used by 1 1/2 of the 
> 23 architectures, neither of which happens to use highmem.  If you 
> consider swiotlb to be a general purpose mechanism, then presumably the 
> other 21 1/2 architectures are at least potential users (and 6 1/2 of 
> those have highmem configurations).  If you base your judgement of 
> what's a "generically useful" change based on what the current users 
> need, then you'll naturally exclude the requirements of all the other 
> (potential) users.
>
> And the matter arises now because we're trying to unify the use of 
> swiotlb in x86, bringing the number of users up to 2.
>
>> I'm especially against the highmem support. As you said, the rest looks 
>> fine but if you go with pci-swiotlb_32.c, I think that you don't need 
>> the most of them.
>>   
>
> I really don't want to have to duplicate a lot of code just to 
> incorporate a few small changes.  In fact the original Xen patch set 
> included its own swiotlb implementation, and that was rejected on the 
> grounds that we should use the common swiotlb.c.

duplicating that would not be a very good design - and 32-bit highmem is a 
reality we have to live with for some time to come. The impact:

   10 files changed, 251 insertions(+), 81 deletions(-)

looks rather to the point and seems relatively compressed. In fact 32-bit 
Xen could end up being the largest user (and tester) of swiotlb facilities 
in general, as modern 64-bit platforms tend to have hw IOMMUs. Having more 
code sharing and more testers is a plus.

	Ingo
