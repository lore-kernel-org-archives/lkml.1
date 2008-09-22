Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbYIVUdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbYIVUdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYIVUcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:32:53 -0400
Received: from SMTP.andrew.cmu.edu ([128.2.10.85]:37598 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbYIVUcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:32:52 -0400
Message-ID: <48D80127.7020602@cmu.edu>
Date: Mon, 22 Sep 2008 16:33:43 -0400
From: George Nychis <gnychis@cmu.edu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: printing current system time from kernel space
References: <48D72AAD.3000805@cmu.edu>	 <1f1b08da0809221328v19f84fb9n7c535f6f01157ba@mail.gmail.com> <1f1b08da0809221330r11f3b82l48509dbc1ea4bb63@mail.gmail.com>
In-Reply-To: <1f1b08da0809221330r11f3b82l48509dbc1ea4bb63@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



john stultz wrote:
> On Mon, Sep 22, 2008 at 1:28 PM, john stultz <johnstul@us.ibm.com> wrote:
>> On Sun, Sep 21, 2008 at 10:18 PM, George Nychis <gnychis@cmu.edu> wrote:
>>> I am looking to measure the latency of USB data between kernel space and
>>> user space.  The user space driver uses a URB to get data from the device to
>>> the kernel and finally to user space.
>>>
>>> To measure this latency, I was thinking of printing the current system time
>>> when a read occurs/succeeds in drivers/usb/core/devio.c at the function
>>> usbdev_read(), and then again in user space when the URB succeeds in
>>> reading.  Then, I could subtract the two times to get the latency.
>>>
>>> I spent some time googling, but could not find out how or if it is possible
>>> to read the current system time in kernel space.  I could insert a printk()
>>> somewhere in usbdev_read() then.
>>>
>>> If it is not possible to read the current system time, is there some other
>>> shared clock between kernel and user space that I could use for this?
>> Kernel: getnstimeofday()
>> Userland: clock_gettime(CLOCK_MONOTONIC, ...)
>>
>> Those two should give you the same data. So printing timespecs from
>> kernel space that come from getnstimeofday() and comparing it to
>> userland clock_gettime(CLOCK_MONOTONIC,...) hopefully will give you
>> what you want.
> 
> Gah! Typed too fast. The above is wrong. You want to use
> clock_gettime(CLOCK_REALTIME,...)  not CLOCK_MONOTONIC with
> getnstimeofday().
> 
> Sorry for the confusion.
> -john
> 

Thanks John!

This is exactly what I am looking for.

- George
