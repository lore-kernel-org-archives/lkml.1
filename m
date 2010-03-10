Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932644Ab0CJSPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:15:48 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:33435 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab0CJSPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:15:46 -0500
Date: Wed, 10 Mar 2010 11:15:45 -0700
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, willy@linux.intel.com
Subject: Re: [PATCH] PCI: create function symlinks in /sys/bus/pci/slots/N/
Message-ID: <20100310181544.GB10446@ldl.fc.hp.com>
References: <20100308172429.GA20953@ldl.fc.hp.com> <4B95A171.5000207@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B95A171.5000207@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kenji-san,

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Alex Chiang wrote:
>> Create convenience symlinks in sysfs, linking slots to device
>> functions, and vice versa. These links make it easier for users to
>> figure out which devices actually live in what slots.
>>
>> For example:
>>
>> sapphire:/sys/bus/pci/slots # ls
>> 1  10  2  3  4  5  6  7  8  9
>>
>> sapphire:/sys/bus/pci/slots # ls -l 3
>> total 0
>> -r--r--r-- 1 root root 65536 Aug 18 14:10 address
>> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function0 ->
>> ../../../../devices/pci0000:23/0000:23:01.0
>> lrwxrwxrwx 1 root root     0 Aug 18 14:10 function1 ->
>> ../../../../devices/pci0000:23/0000:23:01.1
>>
>
> I usually get the similar information like the followings. Is
> it not enough for you?
>
> # /sbin/lspci -s `cat /sys/bus/pci/slots/1/address`
> 40:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
> 40:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
>
>> sapphire:/sys/bus/pci/slots # ls -l 3/function0/slot
>> lrwxrwxrwx 1 root root 0 Aug 18 14:13 3/function0/slot ->
>> ../../../bus/pci/slots/3
>
> IIRC, the latest 'lspci' command shows physical slot
> information (you added this useful feature, didn't you?). Is it
> not enough for you?

You're right, it's certainly possible to get all that information
using lspci (and yes, I did add the physical slot information ;).

I just thought that these symlinks would be quite convenient, so
that you don't have to traverse around in the sysfs tree quite so
much if you want to find other properties of your physical
device, such as net:ethX, etc.

However, I talked with my manageability userspace team and they
do not really need the links either.

I'll leave it up to Jesse. I think this is a useful feature, I
don't think it's too hard to support as a kernel ABI, but I also
agree that it's not entirely necessary.

Thanks.
/ac

