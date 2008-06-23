Return-Path: <linux-kernel-owner+w=401wt.eu-S1759249AbYFWP76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249AbYFWP76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 11:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbYFWP7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 11:59:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49455 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbYFWP7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 11:59:49 -0400
Message-ID: <485FC6C7.5030001@nokia.com>
Date: Mon, 23 Jun 2008 18:52:39 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
References: <Pine.LNX.4.44L0.0806221521330.21150-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806221521330.21150-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jun 2008 15:53:16.0216 (UTC) FILETIME=[3FF13380:01C8D549]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[I'm not subscribed to this list, so please CC: me when you answer]

ext Alan Stern wrote:
> On Sun, 22 Jun 2008, Rene Herman wrote:
> 
>> On 22-06-08 18:55, Stefan Becker wrote:
>>
>>> I get random machine lockups when accessing my USB harddrive with 
>>> kernels 2.6.24/25. They don't occur with kernel 2.6.23. During testing I 
>>> figured out that it has something to do with the USB Bluetooth adaptor. 
>>> If I remove it before the testing I don't get any lockups.
> 
> Does the same problem still occur in 2.6.26-rc7?

Yes.


>  Does it occur if you rmmod ehci-hcd?

Yes, i.e. it also happens when the external hardrive runs as USB 1.1 
device with 12mpbs.


> Machine lockups are awfully hard to debug.  Can you get any information
> at all (like Alt-SysRq-T) when this happens?

SysRq does not work when the machine locks up. I forgot to mention that 
the test machine is a single CPU machine and that the CPU fan starts to 
run full speed when the lockup occurs.

Guessing from the commit returned by git bisect there is a locking 
error, i.e. the CPU runs into a spinlock that is already locked and 
therefore busy loops.


> Can you add debugging
> printk statements to the USB bluetooth driver to try and localize where
> the hang occurs?

Any suggestions where to start?


>>> git bisect resulted in the following bad commit:
>>>
>>> e9df41c5c5899259541dc928872cad4d07b82076 is first bad commit
>>> commit e9df41c5c5899259541dc928872cad4d07b82076
>>> Author: Alan Stern <stern@rowland.harvard.edu>
>>> Date:   Wed Aug 8 11:48:02 2007 -0400
>>>
>>>     USB: make HCDs responsible for managing endpoint queues
> 
> Knowing this doesn't help much without more information.

Too bad. Each bisect cycle took 2-3 hours and the whole process took me 
3 days :-( :-(

That commit has spinlock changes so I hoped that it would be a good 
starting point. Is there a way to track the locks?


> Do you have any idea why nobody else has reported this sort of problem?  
> Is it reproducible on other machines?

I attached both USB devices to another, newer dual core laptop. I 
couldn't reproduce the problem there, even when I simulated a single CPU 
machine with maxcpus=1.

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
