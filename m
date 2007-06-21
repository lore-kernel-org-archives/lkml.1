Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbXFUJY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbXFUJY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 05:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbXFUJYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 05:24:44 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47784 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbXFUJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 05:24:43 -0400
Message-ID: <467A43BC.7030309@bx.jp.nec.com>
Date: Thu, 21 Jun 2007 18:24:12 +0900
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [RFC][PATCH -mm take5 4/7] using symlink for the net_device
References: <466FC455.5060001@bx.jp.nec.com> <466FC6ED.9060208@bx.jp.nec.com>	 <a781481a0706130949j7b35e33ds9cda5d8a551c9d7d@mail.gmail.com>	 <a781481a0706131203g405a4407y1212bb397f14e8eb@mail.gmail.com>	 <4677AA23.1080708@bx.jp.nec.com> <a781481a0706190740w14ae94f1r1ea8449524c5fb99@mail.gmail.com>
In-Reply-To: <a781481a0706190740w14ae94f1r1ea8449524c5fb99@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Satyam,

> In any case, however, the point to extend the critical section here
> to encapsulate all the three parts still stands. We wouldn't want
> ioctl(NETCON_REMOVE_TARGET) on the specified target to
> return without removing the target that the user specified just
> because that target's ethernet interface happens to be currently
> undergoing a name change. The correct behaviour would be to
> sleep on a mutex till the renaming has completed (which will
> then relinquish the mutex) and then (after acquiring the mutex)
> proceed to remove it, IMHO.

You're right. I misunderstood. All the three parts needs to encapsulate.

>> >> +static char *make_netdev_class_name(char *netdev_name)
>> >> +{
>> >> +       char *name;
>> >> +
>> >> +       name = kasprintf(GFP_KERNEL, "net:%s", netdev_name);
>> >
>> > Why the "net:" prefix in the filename?
>>
>> Because I drew upon dev_change_name() method in net/core/dev.c.
>> The device_rename() in the above function makes use of same prefix
>> related to netdev.
> 
> I think you're referring to make_class_name() here? That seems to
> be somewhat bulkier than simply being a wrapper over kasprintf()
> like the make_netdev_class_name() here. I'd definitely recommend
> not obfuscating this simple functionality here.

I understand. The wrapper method such as make_netdev_class_name() isn't
appropriate in this case.

Thanks
-- 
Keiichi KII
NEC Corporation OSS Platform Development Division
E-mail: k-keiichi@bx.jp.nec.com

