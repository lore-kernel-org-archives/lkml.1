Return-Path: <linux-kernel-owner+w=401wt.eu-S1756366AbYDPE1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756366AbYDPE1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 00:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYDPE1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 00:27:22 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:39227 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbYDPE1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 00:27:21 -0400
Date: Tue, 15 Apr 2008 22:27:15 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: x86 git tree broken (bisected)
In-reply-to: <fa.qs5oa+YMIJd6h2hpuGCULc8ODY4@ifi.uio.no>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Message-id: <48058023.7080501@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.2mJjVaMdmV5IWp3mQiYHE1u4pHU@ifi.uio.no>
 <fa.SO/I64FxJXD1oLBH54BTs4pc56c@ifi.uio.no>
 <fa.fJC0A/aGr6H8XE94NUuvl1ixoc0@ifi.uio.no>
 <fa.qs5oa+YMIJd6h2hpuGCULc8ODY4@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday, 14 of April 2008, Yinghai Lu wrote:
>> On Mon, Apr 14, 2008 at 1:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>> On Monday, 14 of April 2008, Yinghai Lu wrote:
>>>  > On Sun, Apr 13, 2008 at 5:19 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>  > >
>>>  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
>>>  > >  > On Sun, Apr 13, 2008 at 3:10 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>  > >  > >
>>>  > >  > > On Monday, 14 of April 2008, Yinghai Lu wrote:
>>>  > >  > >  > On Sun, Apr 13, 2008 at 9:12 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>>  > >  > >  > ...
>>>  > >  > >  > >  > can you try to apply the patch i sent to you about agp bridge order
>>>  > >  > >  > >  > reading for buggy silicon?
>>>  > >  > >  > >  >
>>>  > >  > >  > >  > Please boot kernel with "debug"...
>>>  > >  > >  > >  >
>>>  > >  > >  > >  > I want to verify if you can get
>>>  > >  > >  > >  >
>>>  > >  > >  > >  > "
>>>  > >  > >  > >  > Aperture conflicts with PCI mapping.
>>>  > >  > >  > >  > "
>>>  > >  > >  > >  >
>>>  > >  > >  > >  > in your boot log...
>>>  > >  > >  > >
>>>  > >  > >  > >  It's not present in there:
>>>  > >  > >  > >
>>>  > >  > >  > >  rafael@albercik:~> grep Aperture failing-with-patch-dmesg.log
>>>  > >  > >  > >  Aperture too small (32 MB)
>>>  > >  > >  > >  Aperture from AGP @ de000000 size 4096 MB (APSIZE 0)
>>>  > >  > >  > >  Aperture too small (0 MB)
>>>  > >  > >  > >  agpgart: Aperture pointing to RAM
>>>  > >  > >  > >  agpgart: Aperture from AGP @ de000000 size 4096 MB
>>>  > >  > >  > >  agpgart: Aperture too small (0 MB)
>>>  > >  > >  > >
>>>  > >  > >  > >  Full dmesg output attached.
>>>  > >  > >  >
>>>  > >  > >  > please check attached debug patch. and check if you can change GART
>>>  > >  > >  > size in your BIOS setup to 64M instead of 32M
>>>  > >  > >
>>>  > >  > >  Hm, what tree am I supposed to apply it too:
>>>  > >  > >  (1) current x86 git
>>>  > >  > >  (2) current x86 git w/ some of your previous patches (which ones in this case)
>>>  > >  > >  (3) failing (old) x86 git
>>>  > >  > >  (4) failing (old) x86 git w/ some of your previous patches (which ones in this
>>>  > >  > >     case)?
>>>  > >  >
>>>  > >  > (1) current x86.git
>>>  > >
>>>  > >  Attached is dmesg output from current x86.git with debug_gart_checking.patch
>>>  > >  applied.
>>>  >
>>>  > please test the final one ... ...
>>>  >
>>>  > You should get back 64M memory back.
>>>
>>>  Tested (current x86.git), dmesg output attached.
>> thanks.
>>
>> looks good. as expected...
>>
>> Checking aperture...
>> AGP bridge at 00:04:00
>> Aperture from AGP @ de000000 old size 32 MB
>> Aperture size 4096 MB (APSIZE 0) is not right, using settings from NB
>> Aperture from AGP @ de000000 size 32 MB (APSIZE 0)
>> Node 0: aperture @ de000000 size 32 MB
>> Aperture too small (32 MB) than (64 MB)
>> ...
>> agpgart: Detected AGP bridge 20
>> Setting up ULi AGP.
>> agpgart: AGP aperture is 32M @ 0xde000000
> 
> BTW, what exactly would be the benefit of increasing the aperture size, given
> that I use a PCI Express graphics adapter?

The kernel uses the AGP GART aperture as an IOMMU. If you have >4GB of 
RAM and lots of devices with DMA addressing limits, more GART space 
would help prevent the IOMMU space from being exhausted.
