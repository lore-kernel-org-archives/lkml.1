Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYIVUaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYIVUaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 16:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753381AbYIVUaf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 16:30:35 -0400
Received: from el-out-1112.google.com ([209.85.162.183]:64228 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200AbYIVUae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 16:30:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Z5gP49+AG4vUAZeI/tggWX82Htqyg9oC1v88XbsorXFr73mcMyp9SqF5VUKZa9wUQH
         Vg7AHUgAPX7xWYK8pog+wrc3cwnQZXlhWxpB06T0hG36Y96NXvS0yyzc9jaUOlbP2jzl
         29Ypw4ByJR4CfgH4aj3Ch8a/q7wbyWrGWjHDA=
Message-ID: <1f1b08da0809221330r11f3b82l48509dbc1ea4bb63@mail.gmail.com>
Date: Mon, 22 Sep 2008 13:30:33 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "George Nychis" <gnychis@cmu.edu>
Subject: Re: printing current system time from kernel space
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1f1b08da0809221328v19f84fb9n7c535f6f01157ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48D72AAD.3000805@cmu.edu>
	 <1f1b08da0809221328v19f84fb9n7c535f6f01157ba@mail.gmail.com>
X-Google-Sender-Auth: 1f6c3d760e88417c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 1:28 PM, john stultz <johnstul@us.ibm.com> wrote:
> On Sun, Sep 21, 2008 at 10:18 PM, George Nychis <gnychis@cmu.edu> wrote:
>> I am looking to measure the latency of USB data between kernel space and
>> user space.  The user space driver uses a URB to get data from the device to
>> the kernel and finally to user space.
>>
>> To measure this latency, I was thinking of printing the current system time
>> when a read occurs/succeeds in drivers/usb/core/devio.c at the function
>> usbdev_read(), and then again in user space when the URB succeeds in
>> reading.  Then, I could subtract the two times to get the latency.
>>
>> I spent some time googling, but could not find out how or if it is possible
>> to read the current system time in kernel space.  I could insert a printk()
>> somewhere in usbdev_read() then.
>>
>> If it is not possible to read the current system time, is there some other
>> shared clock between kernel and user space that I could use for this?
>
> Kernel: getnstimeofday()
> Userland: clock_gettime(CLOCK_MONOTONIC, ...)
>
> Those two should give you the same data. So printing timespecs from
> kernel space that come from getnstimeofday() and comparing it to
> userland clock_gettime(CLOCK_MONOTONIC,...) hopefully will give you
> what you want.

Gah! Typed too fast. The above is wrong. You want to use
clock_gettime(CLOCK_REALTIME,...)  not CLOCK_MONOTONIC with
getnstimeofday().

Sorry for the confusion.
-john
