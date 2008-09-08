Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYIHOgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYIHOgh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 10:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752168AbYIHOg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 10:36:29 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:52672 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYIHOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 10:36:29 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=icixEd09jNonJmmBt_0A:9 a=a57-ocA9lIg3CiFYX589i6sY9j0A:4 a=7iKYwcdqit8A:10 a=9qyrBdZ3oNQA:10
Message-ID: <48C5386A.7010807@shaw.ca>
Date: Mon, 08 Sep 2008 08:36:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Q: (2.6.16 & ext3) bad SMP load balancing when writing to ext3
 on slow device
References: <fa.iG3Mum/QrNI8vr+DNw6zItBIFJM@ifi.uio.no> <48C2C8C3.8080706@shaw.ca> <48C4F3E9.20586.6C3971@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
In-Reply-To: <48C4F3E9.20586.6C3971@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich Windl wrote:
> On 6 Sep 2008 at 12:15, Robert Hancock wrote:
> 
>> Ulrich Windl wrote:
>>> Hi,
>>>
>>> while copying large remote files for an USB memory stick formatted with ext3 using 
>>> scp, I noticed a stall in wrie speed. Looking at the system with top I saw:
>>> top - 09:25:25 up 55 days, 23:49,  2 users,  load average: 11.09, 7.41, 4.43
>>> Tasks: 128 total,   1 running, 127 sleeping,   0 stopped,   0 zombie
>>> Cpu0  :  7.6%us,  0.3%sy,  0.0%ni,  0.0%id, 90.4%wa,  0.3%hi,  1.3%si,  0.0%st
>>> Cpu1  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
>>> Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,  0.0%id,100.0%wa,  0.0%hi,  0.0%si,  0.0%st
>>> Cpu3  :  0.0%us,  1.7%sy,  0.0%ni,  0.0%id, 98.3%wa,  0.0%hi,  0.0%si,  0.0%st
>>> Mem:   1028044k total,  1017956k used,    10088k free,    34784k buffers
>>> Swap:  2097140k total,      616k used,  2096524k free,   733100k cached
>>>
>>>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
>>> 11284 root      18   0 29168 1960 1504 D    2  0.2   0:11.81 scp
>>>   137 root      15   0     0    0    0 D    0  0.0  14:16.59 pdflush
>>> 10865 root      15   0     0    0    0 D    0  0.0   0:00.50 kjournald
>>> 11355 root      15   0     0    0    0 D    0  0.0   0:00.09 pdflush
>>> 11396 root      15   0     0    0    0 D    0  0.0   0:00.12 pdflush
>>> 11397 root      15   0     0    0    0 D    0  0.0   0:00.06 pdflush
>>> 12007 root      15   0     0    0    0 D    0  0.0   0:00.02 pdflush
>>> 12070 root      16   0 23976 2376 1744 R    0  0.2   0:00.28 top
>>> 12294 root      15   0     0    0    0 D    0  0.0   0:00.00 pdflush
>>> 12295 root      15   0     0    0    0 D    0  0.0   0:00.02 pdflush
>>> 12296 root      15   0     0    0    0 D    0  0.0   0:00.02 pdflush
>>> 27490 root      10  -5     0    0    0 D    0  0.0   0:02.93 usb-storage
>>>
>>> First, it's impressive that a singly copy job can raise the load to above 10, and 
>>> the next thing is that writing to a slow device can make 4 CPUs (actually two with 
>>> hyperthreading) busy. The pdflush daemons are expected to bring dirty blocks onto 
>>> the device, I guess. Does it make any sense to make four CPUs busy with doing so?
>> They're not busy. IO wait means they have nothing to do other than wait 
>> for IO to complete. It's a bit surprising that you get so many pdflush 
>> threads started up, however..
> 
> Robert,
> 
> back to the question: Assuming the I/O is limited by the controller, communication 
> channel and device, does it ever make any sense to start additional I/O daemons 
> for a device that is already handled by a daemon and doesn't have an alternate 
> communication channel (to make more dirty block go onto the device)? (Assuming no 
> daemon servers more than one device).

I suspect this behavior may have already been changed, you may want to 
try a newer kernel and see..
