Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933445Ab0CKRv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 12:51:26 -0500
Received: from mail.lang.hm ([64.81.33.126]:56088 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933424Ab0CKRvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 12:51:25 -0500
Date: Thu, 11 Mar 2010 09:51:07 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Matthias Schniedermeyer <ms@citd.de>
cc: Mathias Buren <mathias.buren@ie.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: RAID + LUKS + LVM performance
In-Reply-To: <20100311173604.GA17659@citd.de>
Message-ID: <alpine.DEB.2.00.1003110949290.5131@asgard.lang.hm>
References: <OF8365E100.57191C87-ON802576E3.0046BDEA-802576E3.0047EFDF@ie.ibm.com> <20100311173604.GA17659@citd.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010, Matthias Schniedermeyer wrote:

> On 11.03.2010 13:08, Mathias Buren wrote:
>>
>> Hi,
>>
>> (please cc me as I'm not subscribed)
>>
>> I've a friend who's going to set up a fileserver consisting of 8x 1.5TB
>> HDDs, an 8-port PCI-E RAID card (Areca ARC-1220 @
>> http://www.areca.com.tw/products/pcie.htm ) etc.
>> The plan is create a RAID5 array spanning all the disks, then create 4
>> partitions. These 4 partitions would be encrypted using LUKS (Twofish or
>> AES256).
>> These 4 encrypted partition would be set up in RAID0 using Linux' software
>> (mdadm), then LVM would be used on top of that (one big PV, one big VG and
>> a big LV or so).
>>
>> The reason for this is that kcryptd is not multithreaded (afaik). By having
>> 4 encrypted partitions, then md0 on top of them, I'm forcing 4 kcryptd
>> processes to run on all four cpu cores whenever something is written to the
>> disks, which should improve (encryption) performance.
>>
>> Is this a good way of doing it, or is there a smarter way?
>
> The setup you describe would only work with SSDs. HDDs would seek
> themselves to death.
>
> The problem is the RAID-0 over the 4 partitions. At that point you would
> need, instead of the 4 partitions, something that is round-robin. So
> that the mapping of the (physical) blocks from the upper to the lower
> would be effectivly linear/unchanged.
>
> AFAIK something like that is (currently) not possible.

linux software raid (the md tools) support linear or striped modes for 
raid0, so what you are looking for is available.

however I think that defeats part of the OPs purpose, which was to try and 
spread the I/O across all 4 partitions to be able to use multiple cores 
for the encryption.

David Lang
