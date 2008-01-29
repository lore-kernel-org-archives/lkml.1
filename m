Return-Path: <linux-kernel-owner+w=401wt.eu-S1763265AbYA2NVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763265AbYA2NVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763452AbYA2NSB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:18:01 -0500
Received: from michael.checkpoint.com ([194.29.32.68]:65224 "EHLO
	michael.checkpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763624AbYA2NR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:17:57 -0500
Message-ID: <479F278D.3010905@checkpoint.com>
Date: Tue, 29 Jan 2008 15:18:05 +0200
From: Yoav Artzi <yoavar@checkpoint.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. I am aware of these issues and we already have a pretty capable 
layer to deal with these issues (unfortunately, it was very necessary). 
My problem is not with the data carried by the IOCTL, but with IOCTL 
command code itself, which comes out wrong on the kernel side. And my 
problem is not only in the size data, but also in other fields.

IOCTL command code:

1 byte: W/R/RW                                       -------- Passes 
through fine

1 byte: size of data carried                         -------- DOESN'T 
PASS THROUGH

1 byte: identifier character of the module   -------- Passes through fine

1 byte: IOCTL number                               -------- DOESN'T PASS 
THROUGH


The funny thing is that I always get the same IOCTL command code on the 
kernel side, no matter what I send using the ioctl() system call.


Any idea?


Thanks


-------- Original Message  --------

Subject: Re: Sending IOCTLs from 32-bit userland to 64-bit Kernel module
From: Michael Tokarev <mjt@tls.msk.ru>
To: Yoav Artzi <yoavar@checkpoint.com>
Date: Tuesday, January 29, 2008 3:05:01 PM

> Yoav Artzi wrote:
>  
>> Hi,
>>
>>
>> I have a 32-bit user land application which sends an IOCTL to a 64-bit
>> Kernel module. I have a few different cmd codes that I can send through
>> the IOCTL. For some reason I seem to always get the same IOCTL cmd from
>> user land, no matter what the ioctl() call is given. This cmd code that
>> I get has some bytes (W/R and the module code) that are OK, but the rest
>> is just garbage or zeros. This was originally a 32-bit system, and we
>> are no converting the Kernel module to 64-bit, so maybe there's
>> something special for 32-64 communication that miss.
>>     
>
> Please see numerous examples in kernel source, in many files named
> compat_ioctl.c.  If your ioctls uses structures with fields that
> have different sizes in 32- and 64-bit worlds (most notable int,
> various enums etc), there should be corresponding translation
> layer as in those examples.  If it's your kernel code, that is.
> (And try to avoid such types there, use u32 or u64 and the like
> that explicitly specify size).
>
> Another possible problem is different alignment of fields in
> 64- vs 32-bits worlds.
>
>  
>> I am working on Linux Kernel v2.6.18.
>>     
>
> If the kernel side isn't your code, the chances are quite high
> that this problem has long been fixed in more recent kernels.
>
> /mjt
>
> Scanned by Check Point Total Security Gateway.
>
>   


