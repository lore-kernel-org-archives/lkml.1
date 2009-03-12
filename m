Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZCLIGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZCLIGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbZCLIFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:05:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:30612 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbZCLIFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:05:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=d93Xx2MCKHXpVY5+83eiaAWoxg0L9ucQ3CC0Rkv6Ug9tcBSNU5PSFfJNeafEppuG9r
         hj26vTWh+GoDZHenWSiL3O51Ff5Y2By9lo0S5bDaIIE1S7qk+oR6L9CdPGQq+CET1cgx
         HlJunLUtbaCE1+/KHjohKJdfJuz7+oQ2xH2TA=
MIME-Version: 1.0
In-Reply-To: <200903031452.43086.nickpiggin@yahoo.com.au>
References: <m2hc2yulrw.fsf@gmail.com>
	 <200903021811.43653.nickpiggin@yahoo.com.au>
	 <38b2ab8a0903020530j18921202r32f73382ff5f0aa@mail.gmail.com>
	 <200903031452.43086.nickpiggin@yahoo.com.au>
Date: Thu, 12 Mar 2009 09:05:39 +0100
Message-ID: <38b2ab8a0903120105s59f21e0dv1dd67df41dcb2f9d@mail.gmail.com>
Subject: Re: Question regarding concurrent accesses through block device and 
	fs
From: Francis Moreau <francis.moro@gmail.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Nick,

Sorry for the long delay before my answer, but I don't have enough
time to dig the kernel source.

On Tue, Mar 3, 2009 at 4:52 AM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Tuesday 03 March 2009 00:30:18 Francis Moreau wrote:
>> Nick Piggin <nickpiggin@yahoo.com.au> writes:
>> > On Monday 02 March 2009 08:07:30 Francis Moreau wrote:
>> >> This is the case where I can't find when the metadata are actually
>> >> written back to the disk by the flushers. I looked at
>> >> writback_inodes() but I fail to find this out.
>> >>
>> >> Could you point out the place in the code where this happen ?
>> >
>> > I guess it picks them up via their block device inodes.
>>
>> Probably but I don't find the actual place.
>
> It was an educated guess ;) I'm quite sure it does.
>

Ok I think I got the idea now. I though block device main purpose was
to handle block nodes such as /dev/sdx but it isn't.

>
>> I looked at the place where page are normally written back to disk (ie
>> in background_writeout()) but I can see only the writeback of data, not
>> metadata...
>
> What are you expecting writeback of metadata to look like? To the
> core kernel it looks the same as writeback of data.
>

I don't know. I was just thinking that since metadata are special since they
handle critical file system information, the kernel did treat them specially.

> But the cache layer on top of that ensures it *appears* not to be mixed
> up. A problem arises when the system crashes in the middle of this, and
> we lose that information and see a mixed up filesystem. Hence journalling
> filesystems.

Ok I guess I win a new tour in the kernel code ;) to understand how the cache
layer do that.

thanks a lot.
-- 
Francis
