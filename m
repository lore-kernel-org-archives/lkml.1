Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbXCTTXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbXCTTXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934043AbXCTTXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:23:49 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:48996 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S934041AbXCTTXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:23:48 -0400
Date: Tue, 20 Mar 2007 10:58:20 -0800 (PST)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
cc: Theodore Tso <tytso@mit.edu>, Artem Bityutskiy <dedekind@infradead.org>,
       Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
In-Reply-To: <1174406395.30079.139.camel@zod.rchland.ibm.com>
Message-ID: <Pine.LNX.4.63.0703201049310.8684@qynat.qvtvafvgr.pbz>
References: <20070318162720.GI10459@waste.org>  <1174236579.17249.6.camel@sauron>
 <20070318191812.GM4892@waste.org>  <20070318203149.GC29295@crusty.rchland.ibm.com>
  <20070319170838.GP4892@waste.org>  <1174328188.30079.46.camel@zod.rchland.ibm.com>
  <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron> 
 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron> 
 <20070320135231.GA6043@thunk.org> <1174406395.30079.139.camel@zod.rchland.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007, Josh Boyer wrote:

> On Tue, 2007-03-20 at 09:52 -0400, Theodore Tso wrote:
>> As a suggestion, let's stop right here and see if we can get both
>> sides talking in a more constructive fashion.  Maybe it's just me, but
>> I see both sides talking past each other in a rather dramatic fashion.
>
> Perhaps, yes.  Though I've been trying to be open to Matt's suggestions.
> Please don't mistake confusion for hostility.
>
>> There a number of red herrings that have been introduced in this
>> discussion; of *course* the existing block device layer can handle
>> FLASH devices; Matt is proposing that they be extended.  And of
>
> Sure.  But the larger question is *should* it be extended to do so.
>
>> *course* you woulnd't propose to use ext2 on top of an 128k blocksize,
>> anymore than you would force a flash filesystem to use a 4k or 512
>> byte blocksize; there are plenty of configurations that won't make
>
> Except that flash filesystems don't use block devices at all.  They use
> MTD interfaces.
>
>> sense, and by itself this isn't an indictment of the core idea that
>> the block device layer and dm should be augmented to encompass flash
>> functionality.
>
> This is where the concept starts to lose me.  Augmented how?  To not use
> MTD at all (obviously with the exception of the low-level flash
> drivers)?  How is that not going to duplicate MTD?  Etc, etc.

What Matt and Ted are looking at is the question 'are flash devices close enough 
to other block devices that it would make sense to change the existing linux 
definition of a block device to handle the special requirements of flash'

if the block device layer can be reasonably modified to accomodate flash, then 
doing so greatly improves flexibility and maintainability. It would also reduce 
the overall code size since existing features of the block layer (for example 
snapshots) would not need to be duplicated or re-written for the flash block 
layer.

if not then so be it.

everyone understands that flash has different requirement from a hard drive as a 
block device, what isn't clear to the people reading this thread (and reviewing 
the code) is why you believe that it is _so_ different that it's impossible to 
consider extending the linux definition of a block device.

the fact that the native eraseblock size is significantly larger isn't a factor.

the fact that you erase in large blocks and then write in smaller blocks is a 
difference, and one that the current block layer doesn't understand. but this is 
a difference that the current block layer could be changed to understand. it's 
not something that would justify a seperate-but-equal block layer for flash 
devices.

as Ted notes, the idea that block sizes may not be powers of 2 (128k-128b from 
his e-mail) _may_ end up being a big enough difference that it's not worth 
teaching the exising block layer how to deal with, but it's not clear why you 
are useing this odd size.

this is why you are being asked for further explinations.

David Lang
