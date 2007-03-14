Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbXCNW5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbXCNW5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 18:57:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXCNW5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 18:57:32 -0400
Received: from note.orchestra.cse.unsw.EDU.AU ([129.94.242.24]:41605 "EHLO
	note.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269AbXCNW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 18:57:32 -0400
From: Kandan Venkataraman <kven709@cse.unsw.EDU.AU>
To: Christoph Hellwig <hch@infradead.org>
Date: Thu, 15 Mar 2007 09:57:09 +1100 (EST)
X-X-Sender: kven709@williams.orchestra.cse.unsw.EDU.AU
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] Loop device - Tracking page writes made to a loop device
 through mmap
In-Reply-To: <20070313203244.GA13914@infradead.org>
Message-ID: <Pine.LNX.4.64.0703150928270.10389@williams.orchestra.cse.unsw.EDU.AU>
References: <Pine.LNX.4.64.0703140712080.18655@williams.orchestra.cse.unsw.EDU.AU>
 <20070313203244.GA13914@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2007, Christoph Hellwig wrote:

> On Wed, Mar 14, 2007 at 07:21:41AM +1100, Kandan Venkataraman wrote:
>> All comments have been taken care of.
>>
>> Description:
>>
>> A  file_operations structure variable called loop_fops is initialised with
>> the default block device file operations (def_blk_fops).
>> The mmap operation is overriden with a new function called loop_file_mmap.
>
> NACK.  block device driver should never ever play around with file
> operations themselves.  If you want functionality like the one you
> have please don't overload the loop driver, but start a new (character)
> driver doing specificaly what you want.  And even then I'm not sure
> we'd want functionality like this in the mainline tree, but at least
> we can have an open discussion if it's done properly.
>

The reason I chose the loop device was the following:

The loop device has backing storage and makes use of the page cache. The 
nopage method for all block device files and most disk files is 
implemented by filemap_nopage. This function uses the page cache. Thus, 
this allows me to mmap a large address space.

If I wrote a character device, I would have to store the contents in 
kernel memory as the function filemap_nopage is not suitable for character 
devices. This would severly restrict the size of my mmap.

I am out my depth here, any pointers on how to proceed would be very 
helpful

Thanks
Kandan
