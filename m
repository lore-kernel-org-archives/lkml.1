Return-Path: <linux-kernel-owner+w=401wt.eu-S1761672AbYDYJkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761672AbYDYJkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 05:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759795AbYDYJjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 05:39:51 -0400
Received: from araneidae.co.uk ([62.3.233.233]:3691 "EHLO mail.araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759773AbYDYJju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 05:39:50 -0400
Date: Fri, 25 Apr 2008 09:39:26 +0000 (GMT)
From: Michael Abbott <michael@araneidae.co.uk>
To: Ben Dooks <ben-linux@fluff.org>
cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DM9000: Reimplement 2-resource device specification
 (fwd)
In-Reply-To: <20080424173432.GE16284@fluff.org.uk>
Message-ID: <20080425090403.W61380@saturn.araneidae.co.uk>
References: <20080424125217.M52274@saturn.araneidae.co.uk>
 <20080424173432.GE16284@fluff.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Ben Dooks wrote:
> On Thu, Apr 24, 2008 at 12:57:08PM +0000, Michael Abbott wrote:
>> From: Michael Abbott <michael.abbott@diamond.ac.uk>
>>
>> [PATCH] DM9000: Reimplement 2-resource device specification
>>
>> In commit 1a5f1c4ff80f522555d78d4dd0109f18395c6d83 a change was made to
>> the handling of the resources passed the DM9000 device.  Unfortunately,
>> if only two resources are passed (the read and write register in the same
>> area) the pointer db->irq_res ends up being used without being initialised.
>>
>> This patch tidies this up a little.  Only one architecture class,
>> blackfin, uses two resource specification, so it may be better to enforce
>> three resource specification as before by simply removing the 0 and 2
>> resource branches from dm9000_probe.
>
> I think then we should probably make the driver simpler and remove the
> special case for the two resources... any small saving of using just
> two resources is probably cancelled out by the extra code needed.

I think this is a good idea.  The only qualms I had about this were: 1/ 
this involves changes to a device which I'm completely unable to test (but 
I think we agree it's already broken without this patch);  2/ I don't know 
how much extra resources are involved in the extra memory region request 
and io remap.

>> +#define res_size(_r) (((_r)->end - (_r)->start) + 1)
> I'd like to see something like this as an inline function in the
> relevant header, and some patches to get other users to find it.

This macro was in the original commit which introduced dm9000 support,
a1365275e745bb0a173c918a52bcdfa6ce122f7e (I just had to move it up one 
function).

I guess the natural home for something like this would be linux/ioport.h.
(I do wish there were more detailed comments in the header files on *how* 
the functions defined there behave and are intended to be used!)

>> -
>>  		if (pdata->outblk != NULL)
>>  			db->outblk = pdata->outblk;
>> -
>>  		if (pdata->dumpblk != NULL)
>>  			db->dumpblk = pdata->dumpblk;
> I'd rather not see spacing changes done, especially as I don't like
> to see lots of code cramped together.

Sorry, had a feeling that didn't really belong in the patch.  For my own 
code I prefer whitespace to serve a stronger role (breaking up logical 
groups; in my mind the assignments above go together), but I'll refrain 
from layout hacks to code I'm not rewriting!

> -- 
> Ben (ben@fluff.org, http://www.fluff.org/)
>  'a smiley only costs 4 bytes'
4 bytes?  In what encoding? ;)
