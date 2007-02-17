Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbXBQTiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbXBQTiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 14:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932802AbXBQTiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 14:38:05 -0500
Received: from mail.tmr.com ([64.65.253.246]:46058 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbXBQTiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 14:38:04 -0500
Message-ID: <45D75A1F.8060504@tmr.com>
Date: Sat, 17 Feb 2007 14:40:15 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: =?ISO-8859-1?Q?C=E9dric_Augonnet?= <cedric.augonnet@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Daniel Aragones <danarag@gmail.com>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
In-Reply-To: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cédric Augonnet wrote:
> 2007/2/15, Andrew Morton <akpm@linux-foundation.org>:
>>
>> Temporarily at
>>
>>   http://userweb.kernel.org/~akpm/2.6.20-mm1/
>>
>> Will appear later at
>>
>>
>> Changes since 2.6.20-rc6-mm3:
>>
>> -minix-v3-support.patch
> 
> Hi Daniel,
> 
> On 2.6.20-rc6-mm3 and 2.6.20-mm1, i get an OOPS when using the minix 3
> file system. I enclose the dmesg and the .config to that mail.
> 
> Here are the steps to reproduce this oops (they involve using qemu to
> run Minix 3)
> - First create a 2GB image using
>      qemu-img create minix.img 2G
>   (Please note that this seem to be producing an eroneous image)
> - Then launch Minix inside qemu to make a minix partition on this
> image using mkfs on the corresponding device.

That's two steps, right? First you make a partition on the "disk" qemu 
provides, then you put a filesystem on the partition? Or did you put a 
filesystem on the raw device?

> - Mount the image on loopback using
>  mount -t minix -o loop minix.img /mnt/qemu/

Does mount know to use Minux3 with this command line?

> - issue a "df" command on /mnt/qemu
> 
> This oops occurs everytime i use df on this directory. However, this
> does not occur if the image was for a 1MB partition. And it does not
> occur if the partition on which we created minix.img was the same as
> the partition on which qemu stands. Sounds like qemu has an issue and
> creates an erroneous partition which linux does not handle correctly.
> 
> Regards, and thanks for your patch by the way !

Having been burned a few times by the fact that qemu provides disk 
images which then (normally) get partitions, I'm not sure you aren't 
having the same problem.

None of which justifies the OOPS, of course, nice kernels don't go down.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

