Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbZGMLSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbZGMLSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 07:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755409AbZGMLSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 07:18:03 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:28681
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755339AbZGMLSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 07:18:02 -0400
Message-ID: <4A5B17E3.3070908@panasas.com>
Date: Mon, 13 Jul 2009 14:17:55 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
References: <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com> <20090709075100.GU2714@wotan.suse.de> <4A59A517.1080605@panasas.com> <20090712144717.GA18163@infradead.org> <20090713065917.GO14666@wotan.suse.de> <4A5AF637.3090405@panasas.com> <20090713090056.GA3452@wotan.suse.de>
In-Reply-To: <20090713090056.GA3452@wotan.suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2009 11:17:57.0969 (UTC) FILETIME=[93567C10:01CA03AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2009 12:00 PM, Nick Piggin wrote:
> On Mon, Jul 13, 2009 at 11:54:15AM +0300, Boaz Harrosh wrote:
>> On 07/13/2009 09:59 AM, Nick Piggin wrote:
>>> On Sun, Jul 12, 2009 at 10:47:18AM -0400, Christoph Hellwig wrote:
>>>> On Sun, Jul 12, 2009 at 11:55:51AM +0300, Boaz Harrosh wrote:
>>>>> I wish you would split it.
>>>>>
>>>>> one - helper to be called by converted file systems
>>>>>       (Which just ignores the ATTR_SIZE)
>>>>> second - to be set into .setattr which does the simple_setsize + above.
>>>>>
>>>>> More clear for FS users like me (and that ugly unmask of ATTR_SIZE)
>>>>>
>>>>> or it's just me?
>>>> Yeah, that seems be a lot cleaner.  But let's wait until we got
>>>> rid of ->truncate for all filesystems to have the bigger picture.
>>> Agreed, if it is a common sequence / requirement for filesystems
>>> then of course I will not object to a helper to make things clearer
>>> or share code.
>>>
>>> I would like to see inode_setattr renamed into simple_setattr, and
>>> then also .setattr made mandatory, so I don't like to cut code out
>>> of inode_setattr which makes it unable to be the simple_setattr
>>> after the old truncate code is removed.
>>>
>> I thought you meant inode_setattr will go away. There will
>> only be simple_setattr() and inode_setattr_nosize()
>>
>> For the time been simple_setattr() will also take care
>> of old ->truncate FSs. And in the absence of .setattr
>> simple_setattr() is called. Have I miss-understood?
>>
>> again please tell me when all this is in effect I want
>> to do the conversion in exofs.
> 
> AFAIKS inode_setattr basically is simple_setattr, so I think at some
> point it should just get renamed to simple_setattr. Adding
> simple_setattr_nosize or similar helper would be fine too. I don't
> care much about the exact details... But anyway these things are not
> so important to this truncate patchset at the moment.
> 

I see. So what is the schedule? when are we to convert all FSs?

> 
>> [BTW these changes are a life saver for me in regard to
>> the kind of things I need to do for pNFS-exports]
> 
> You mean the truncate patches? Well that's nice to know. I
> guess it has always been possible just to redefine your own
> setattr, but now it should be a bit nicer with the truncate
> helpers...
> 

OK, yes redefine .setattr, do the right thing in write_begin/end
and the helpers do help a lot, to the point that it was not safe to
open-code all this work. The situation is much better after your
patchset.

> Thanks,
> Nick

Thanks
Boaz
