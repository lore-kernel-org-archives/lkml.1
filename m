Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbYBALIa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbYBALIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 06:08:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbYBALIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 06:08:20 -0500
Received: from smtp23.orange.fr ([193.252.22.30]:9223 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYBALIT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 06:08:19 -0500
X-ME-UUID: 20080201110817376.5BC9E1C02C4C@mwinf2341.orange.fr
Message-ID: <47A2FD9A.8020809@cosmosbay.com>
Date: Fri, 01 Feb 2008 12:08:10 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Shuduo Sang <sangshuduo@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Lars Noschinski <lklml@ml.noschinski.de>,
       linux-kernel@vger.kernel.org
Subject: Re: How does ext2 implement sparse files?
References: <20080131152823.GA29422@lars.home.noschinski.de>	 <p73myql50d2.fsf@bingen.suse.de> <ee101c360802010234m4a7199e7g4cc9131484529b1c@mail.gmail.com>
In-Reply-To: <ee101c360802010234m4a7199e7g4cc9131484529b1c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuduo Sang a écrit :
> On Feb 1, 2008 2:14 AM, Andi Kleen <andi@firstfloor.org> wrote:
>   
>> Lars Noschinski <lklml@ml.noschinski.de> writes:
>>
>>     
>>> For an university project, we had to write a toy filesystem (ext2-like),
>>> for which I would like to implement sparse file support. For this, I
>>> digged through the ext2 source code; but I could not find the point,
>>> where ext2 detects holes.
>>>
>>> As far as I can see from fs/buffer.c, an hole is a buffer_head which is
>>> not mapped, but uptodate. But I cannot find a relevant source line,
>>> where ext2 makes usage of this information.
>>>       
>> It does not explicitely detect holes; holey data is just never written
>> so no space for it is allocated.
>>
>>     
>
> does anybody know how to make a hole in a large file which already has
> real content from user space application?
> In my project I need this function to delete a piece of content from
> an exist large effectively.
> thanks.
>
>   
Some OSes use fcntl() F_FREESP/F_FREESP64 to be able to free allocated 
space in files (ie make holes if supported by underlying fs)

AFAIK, linux can generically do this only at the end of a file 
(ftruncate()) , not at random points.

XFS has special support for FREESP (it comes from IRIX), implemented as 
an ioctl()

Check for XFS_IOC_FREESP and XFS_IOC_UNRESVSP in fs/xfs/xfs_fs.h





