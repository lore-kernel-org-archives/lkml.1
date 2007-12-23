Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbXLWHgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbXLWHgQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 02:36:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbXLWHgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 02:36:03 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:39153 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbXLWHgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 02:36:01 -0500
Message-ID: <476E0FDF.9030407@davidnewall.com>
Date: Sun, 23 Dec 2007 18:05:59 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Richard D <richard@embunus.com>,
       "'Matthew Bloch'" <matthew@bytemark.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: Testing RAM from userspace / question about memmap= arguments
References: <fk8umh$n7o$1@ger.gmane.org> <20071221125812.GA4052@ucw.cz> <000001c84472$74b245e0$5e16d1a0$@com> <20071222134612.GA4098@ucw.cz> <476D35F6.90900@davidnewall.com> <20071222184759.GB31809@elf.ucw.cz> <476D756A.6060507@davidnewall.com> <20071222205432.GA2221@elf.ucw.cz>
In-Reply-To: <20071222205432.GA2221@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Sun 2007-12-23 07:06:58, David Newall wrote:
>   
>> It's kind of hard to run anything over SSH if it has to be run before 
>> userspace is up.  But the kernel can collect results from a modified 
>> memtest, after it chains back.
>>     
>
> memtest can be ran from userspace, that's the point.
>   

I'm not sure I believe that.  You need to tinker with hardware tables 
before you know what physical RAM is being used.  Sequential virtual 
pages might be mapped to sequential physical RAM, but it might also be 
mapped psuedo-randomly, or even page-reverse-sequential!  How can you do 
a basic walking bit test when you could be accessing pages in random order?

>>> 	1) if linux fixes some problem with PCI quirk or microcod
>>> 	upload, memtest will not see the fix
>>>   
>>>       
>> What are you saying?  Linux is going to fix faulty RAM?
>>     
>
> Yes, that's what CPU microcode update is for. And I want to test my
> RAM with up-to-date microcode.
>   

Don't microcode updates fix CPU bugs?  That's not fixing faulty RAM.  If 
base microcode is so faulty as to make RAM access unreliable, the CPU 
probably won't even POST, let alone boot the kernel and start a whole 
bunch of userspace stuff, before it can get around to checking to see if 
there is new microcode for that CPU and download it.

I suppose a CPU retains microcode updates, once loaded, until power-down 
or some hard reboot that you surely can avoid.  If it does happen that 
you have an update that works around something unrelated to the CPU, for 
example maybe interaction with a bridge, then you can update the CPU 
before running memtest.  Once loaded it's there until power down.

>> These are not RAM faults. The very last thing you want is evidence that
>> you've got a faulty piece of RAM when the fault is actually a hard disk 
>> glitch!
>>     
>
> No, it may be power supply leading to RAM problems. Yes, I want to
> detect that.

I'm sure you don't mean that.  I'm sure you don't want a faulty power 
supply to look like faulty RAM.  No amount of replacing pieces of memory 
is going to solve a faulty power supply.  At worst you'll hit on a 
combination of pieces that pass the test ... and then the system will 
fail, mysteriously, in production.  I'm certain you don't want that.

Anyhow, good luck with your idea.  I think it's crazy, and that you're 
doomed to failure.  Doomed! I tell you.
