Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbZIAP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbZIAP0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZIAP0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:26:11 -0400
Received: from mail.lang.hm ([64.81.33.126]:36034 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754340AbZIAP0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:26:10 -0400
Date: Tue, 1 Sep 2009 08:25:55 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: NeilBrown <neilb@suse.de>
cc: George Spelvin <linux@horizon.com>, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org, pavel@ucw.cz
Subject: Re: raid is dangerous but that's secret (was Re: [patch] ext2/3:
In-Reply-To: <e57f474f060bf2a16437b16aac23fabd.squirrel@neil.brown.name>
Message-ID: <alpine.DEB.2.00.0909010825000.6822@asgard.lang.hm>
References: <20090901111803.11027.qmail@science.horizon.com> <e57f474f060bf2a16437b16aac23fabd.squirrel@neil.brown.name>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, NeilBrown wrote:

> On Tue, September 1, 2009 9:18 pm, George Spelvin wrote:
>>>> An embedded checksum, no matter how good, can't tell you if
>>>> the data is stale; you need a way to distinguish versions in the
>>>> pointer.
>>
>>> I would disagree with that.
>>> If the embedded checksum is a function of both the data and the address
>>> of the data (in whatever address space seems most appropriate) then it
>>> can
>>> still verify that the data found with the checksum is the data that was
>>> expected.
>>> And storing the checksum with the data (where it is practical) means
>>> index blocks can be more dense so on average fewer accesses to storage
>>> are needed.
>>
>> I must not have been clear.  Originally, block 100 has contents version 1.
>> This includes a correctly computed checksum.
>>
>> Then you write version 2 of the data there.  But there's a bit error in
>> the address and the write goes to block 256+100 = 356.  So block
>> 100 still has the version 1 contents, complete with valid checksum.
>> (Yes, block 356 is now corrupted, but perhaps it's not even allocated.)
>>
>> Then we go to read block 100, find a valid checksum, and return incorrect
>> data.  Namely, version 1 data, when we expact and want version 2.
>>
>> Basically, the pointer has to say which *version* of the data it points
>> to,
>> not just the block address.  Otherwise, it can't detect a missing write.
>
> Agreed.  I think the minimum is that the index block must be changed in
> some way whenever data that it points to is changed.  Exactly how
> depends very much of other details of the filesystem layout.
> For a copy-on-write filesystem where changed data is always written
> to a new location, this is very easy to achieve as the 'physical'
> address can probably be used as a version identifier in some way.
> For write-in-place you would need the version information
> to be more explicit as you say, whether a small version number
> or a larger hash of the data.

but then don't you have to update the version on the index (and therefor 
the pointer to that directory), on up to the point where you update the 
root?

David Lang
