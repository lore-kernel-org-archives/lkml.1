Return-Path: <linux-kernel-owner+w=401wt.eu-S1752798AbZFZPXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbZFZPXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 11:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbZFZPXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 11:23:23 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40722 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750720AbZFZPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 11:23:23 -0400
Date: Fri, 26 Jun 2009 11:23:26 -0400
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev]  Coldfire 5271 hitting BUG_ON(page_count(buddy)
	!= 0);
Message-ID: <20090626152326.GA15751@csclub.uwaterloo.ca>
References: <20090625154343.GA10189@csclub.uwaterloo.ca> <4A443EB5.40300@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A443EB5.40300@snapgear.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 26, 2009 at 01:21:25PM +1000, Greg Ungerer wrote:
> Hi Lennart,
>
> Lennart Sorensen wrote:
>> I am hitting a memory management bug and I would love some hints as to
>> how to track down the bug and fix it.
>>
>> The bug hit is line 423 of page_alloc.c which is:
>>
>> BUG_ON(page_count(buddy) != 0);
>>
>> The function it is part of is:
>>
>> static inline int page_is_buddy(struct page *page, struct page *buddy,
>>                                                                 int order)
>> {
>>         if (!pfn_valid_within(page_to_pfn(buddy)))
>>                 return 0;
>>
>>         if (page_zone_id(page) != page_zone_id(buddy))
>>                 return 0;
>>
>>         if (PageBuddy(buddy) && page_order(buddy) == order) {
>>                 BUG_ON(page_count(buddy) != 0);
>>                 return 1;
>>         }
>>         return 0;
>> }
>>
>> I am seeing this both with 2.6.29.1 and 2.6.30 so far.  I unfortunately
>> haven't poked much at the memory management code, so I am not even sure
>> what this is supposed to be doing.  The cpu us a coldfire 5271.
>>
>> I also see crashes causing the kernel to dump lots of hex values.
>> Building the kernel with debug enabled unfortunately seems to move things
>> around enough to make it just lock up instead without any output.
>
> What are you doing at the time you get this?
> Or is it at bootup?

Running a few little test programs.

We are trying to narrow it down to as small a test case as possible
right now.

Pretty much we boot to a busybox shell, then run a while loop that does
a read of an lm75 sensor on i2c and reads an eeprom on i2c, and after
a few loops, the kernel BUG is hit.

Hopefully in an hour or two I will have it narrowed down to a smaller
test case (so far it looks like the lm75 part has nothing to do with it,
so it may simply be the reading of the i2c eeprom that is doing it).
The eeprom is being read using eeprog using the user space i2c bus
access methods.

-- 
Len Sorensen
