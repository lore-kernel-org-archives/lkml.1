Return-Path: <linux-kernel-owner+w=401wt.eu-S965312AbXBFTJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312AbXBFTJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 14:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965369AbXBFTJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 14:09:38 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41049 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965312AbXBFTJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 14:09:37 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Andreas Herrmann" <andreas.herrmann3@amd.com>
Cc: discuss@x86-64.org, "Richard Gooch" <rgooch@safe-mbox.com>,
       "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [discuss] [patch] mtrr: fix issues with large addresses
References: <20070205171959.GF8665@alberich.amd.com>
	<m13b5kw2qj.fsf@ebiederm.dsl.xmission.com>
	<20070206160828.GH8665@alberich.amd.com>
	<m1sldjtbn4.fsf@ebiederm.dsl.xmission.com>
	<20070206184213.GA4628@alberich.amd.com>
Date: Tue, 06 Feb 2007 12:08:12 -0700
In-Reply-To: <20070206184213.GA4628@alberich.amd.com> (Andreas Herrmann's
	message of "Tue, 6 Feb 2007 19:42:13 +0100")
Message-ID: <m1zm7rrtnn.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Andreas Herrmann" <andreas.herrmann3@amd.com> writes:

> On Tue, Feb 06, 2007 at 10:54:23AM -0700, ebiederm@xmission.com wrote:
>> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
>> > On Mon, Feb 05, 2007 at 05:26:12PM -0700, ebiederm@xmission.com wrote:
>> >> "Andreas Herrmann" <andreas.herrmann3@amd.com> writes:
>> >> >
>> >> The limit is per cpu not per architecture.  So if you run a
>> >> cpu that can run in 64bit mode in 32bit mode the limit
>> >> is not 36 bits.  Even PAE in 32bit mode doesn't have that limit.
>> >> 
>> > Good point.
>> >
>> > I totally ignored that on 64 bit cpus in legacy mode
>> > - PAE-paging means up to 52 physical address bits respectively
>> > "physical address size of the underlying implementation"
>> > - for non-PAE-paging with PSE enabled we have 40 bits for AMD and
>> > with PSE36 36 bits for Intel
>> 
>> For non PAE-paging you have 32bits.
>
> You are referring to current Linux implementation?
> The AMD64 architecture increased physical address size in PSE mode to
> 40 bits. So at least it would be possible to use more than 32 bits.

How do you get 40 physical bits in a 32bit page table entry? My memory
is that the low bits in the page table entry were well defined and
accounted for. I'm pretty certain I can account for 6 of the low bits
off the top of my head.  PSE is the page size extension allowing pages 2MB/4MB
pages.  

PAE (physical address extension) gives you a 64bit page table entry
and where you have a place for all of those extra physical bits kick
as I recall.  The limit is 52 bits and current cpus talk about support
40 bits with AMD in the process of going to 48 bits.

Is there a feature I have overlooked?  
That would allow 40 bits with PSE?

>> 
>> Yes.  So base needs to be come a u64. 
>
> I was afraid you'ld say that.
>
>> So base = ((base_hi << 32) | base_lo) >> PAGE_SHIFT.
>> 
>> I see where the 44bit limit comes in.  Do you actually have boxes
>> with > 16TB?
>
> No, I don't have access to such a box. Would be nice though.
>
>> 
>> Regardless it looks like base and possibly size needs to become
>> a u64.  At which time the extra >> PAGE_SHIFT could be meaningless.
>> Either that or because base and size need to be sized in something like
>> megabytes.
>> 
>> I suspect making it a u64 sized in bytes will get the job done and
>> result in simpler code.
>
> Right you are!

> Ok, it is best to do (3).
> I will come up with another patch asap.

Thanks.  Sorry for being a pain.

Eric
