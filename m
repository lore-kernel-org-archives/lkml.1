Return-Path: <linux-kernel-owner+w=401wt.eu-S933163AbZGPTxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933163AbZGPTxu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 15:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932765AbZGPTxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 15:53:49 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:22684
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932582AbZGPTxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 15:53:48 -0400
Message-ID: <4A5F854A.7030101@panasas.com>
Date: Thu, 16 Jul 2009 22:53:46 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: david@lang.hm
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Subject: Re: deterministic scsi order with async scan
References: <alpine.DEB.1.10.0907151801040.9159@asgard> <4A5F100E.9000107@panasas.com> <alpine.DEB.1.10.0907161017180.9159@asgard>
In-Reply-To: <alpine.DEB.1.10.0907161017180.9159@asgard>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jul 2009 19:53:48.0720 (UTC) FILETIME=[22A98B00:01CA064F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2009 08:22 PM, david@lang.hm wrote:
> On Thu, 16 Jul 2009, Boaz Harrosh wrote:
> 
>> On 07/16/2009 04:09 AM, david@lang.hm wrote:
>>> is there any way to get deterministic device ordering with scsi async
>>> scanning?
>>>
>>> currently (2.6.30) it seems that the various scsi busses are loaded in the
>>> order that they are detected, which can vary from boot to boot depending
>>> on how long it takes for the card to initialize.
>>>
>>> would it be possible to detect the cards/drives, but not register them
>>> until all the detection is complete so that they can be registered in a
>>> deterministic order?
>>>
>>> having two drives on two different controllers swap positions from boot to
>>> boot makes it very painful. yes I can make an initrd that fixes this up in
>>> user space by examining each drive and creating links to re-order them,
>>> but this is a lot of work to fix randomization that can be prevented in
>>> the first place.
>>>
>>> David Lang
>> It is highly discouraged to setup any kind of system that depends
>> on device-names for block-devices. mounts have the mount by-label
>> or mount by-uuid. Any other subsystem should go by /dev/disk/by-id/*
>> slinks to find a persistent raw block-device. the id is generated
>> from characteristics inside the disk itself so it will be the same
>> no matter what host connection or bus it is connected too (almost).
>>
>> This is because even if the boot order is consistent, the device-name
>> is so volatile in the life-span of a system. Did I boot with a removable
>> USB inserted. that camera or printer was on or off, disk was connected
>> to the other port. Any such change will break things and give you a very
>> poor user experience.
> 
> for a laptop you areprobably correct, but for a server or embedded system 
> that doesn't have it's hardware changing all the time you are not correct.
> 
> especially on a system with lots of drives, why should I have to create an 
> initrd that goes and searches dozens or hundreds of drives to find out 
> which one to boot from?
> 

there is *no* searching with /dev/disk/by-id/ or /dev/disk/by-uuid/
Udev comes reads a small piece of information and puts up a link.

now: not(initrd+Udev) == Kernel_with_no_legs

> I am building a system that will have two drives in a hardware mirror on 
> one SCSI card, and 160 drives on a FC (SCSI) card. why should my boot have 
> to go and examine all 162 drives to look for an ID on every partition just 
> to find the boot drive?
> 

Again no searching is done here, just read of a sector for uuid and some
query command for by-id

>> I would say that "scsi async" is a grate blessing
> 
> it's great for startup time, but doing the async detection doesn't 
> _require_ doing async registration.
> 
> David Lang

Boaz
