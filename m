Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXFGP0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXFGP0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbXFGP0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:26:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051AbXFGP0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:26:11 -0400
Message-ID: <46682385.1060802@redhat.com>
Date: Thu, 07 Jun 2007 11:25:57 -0400
From: Peter Jones <pjones@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.22-rc4-mm1
References: <20070606020737.4663d686.akpm@linux-foundation.org>	 <4667018D.7020407@googlemail.com> <1181168095.3612.4.camel@lov.localdomain>	 <4667C47C.2010207@googlemail.com> <1181206091.3625.9.camel@lov.localdomain>	  <4667D2DF.30207@googlemail.com> <1181228660.3625.23.camel@lov.localdomain>
In-Reply-To: <1181228660.3625.23.camel@lov.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Thu, 2007-06-07 at 11:41 +0200, Michal Piotrowski wrote:
>> Kay Sievers pisze:
>>> On Thu, 2007-06-07 at 10:40 +0200, Michal Piotrowski wrote:
>>>> Kay Sievers pisze:
>>>>> On Wed, 2007-06-06 at 20:48 +0200, Michal Piotrowski wrote:
>>>>>> Andrew Morton pisze:
>>>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/
>>>>>>>
>>>>>> Kay, your patch gregkh-driver-block-device.patch breaks Fedora 7 initrd
>>>>>> http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.22-rc4-mm1/initrd.jpg
>>>>>>
>>>>>> Please fix it ASAP, I can't test kernel...
>>>>> Do you have CONFIG_SYSFS_DEPRECATED set or unset?
>>>>>
>>>>> Kay
>>>>>
>>>>>
>>>> cat ../linux-mm-bo/.config | grep CONFIG_SYSFS_DEPRECATED
>>>> # CONFIG_SYSFS_DEPRECATED is not set
>>> Oh, could you possibly try (with the block patch included) setting it to
>>> yes and see if it works? That would help to find what's going wrong.
>> I enabled CONFIG_SYSFS_DEPRECATED and 2.6.22-rc4-mm2 boots fine.
> 
> Michal, thanks a lot for the testing.
> 
> Peter, looking at your mkinitrd code, it works only with
> CONFIG_SYSFS_DEPRECATED enabled when block devices are converted to
> class devices.
> Any chance to replace lstat() with stat() while looking for devices in
> sysfs? Remember, _anything_ in sysfs can be symlink or a directory, you
> can't assume one or the other. When things change internally in the
> kernel, we can often provide symlinks for backwards compatibility, but
> lstat() obviously can't works here.

Fixed in mkinitrd-6.0.9-6 , which I'll build now and push to 
updates-testing.  Thanks for getting my attention here.

-- 
   Peter
