Return-Path: <linux-kernel-owner+w=401wt.eu-S1760983AbYETUrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760983AbYETUrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 16:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbYETUrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 16:47:32 -0400
Received: from frodo.howardsilvan.com ([66.119.206.113]:39571 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940AbYETUrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 16:47:31 -0400
Message-ID: <483338DE.8090904@howardsilvan.com>
Date: Tue, 20 May 2008 13:47:26 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Zan Lynx <zlynx@acm.org>
CC: Ray Lee <ray-lk@madrabbit.org>, linux-kernel@vger.kernel.org
Subject: Re: troubleshooting/debugging hard locks
References: <482B3D21.5020903@howardsilvan.com>	 <2c0942db0805141543n20e6eb6eq5fe13fe1cb50d67e@mail.gmail.com> <1210808578.3784.7.camel@localhost> <482BB151.4010109@howardsilvan.com>
In-Reply-To: <482BB151.4010109@howardsilvan.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Howard wrote:
> Zan Lynx wrote:
>> On Wed, 2008-05-14 at 15:43 -0700, Ray Lee wrote:
>>  
>>> On Wed, May 14, 2008 at 12:27 PM, Lee Howard 
>>> <faxguy@howardsilvan.com> wrote:
>>>     
>>
>>  
>>>>  But, without kernel messages indicating where to look to debug... 
>>>> what is
>>>> the best approach to start troubleshooting and debugging this 
>>>> condition?  Is
>>>> there some general debug feature that can be enabled in the kernel 
>>>> that
>>>> would help hone in on the culprit?
>>>>       
>>> There's something called the NMI watchdog, that will print debugging
>>> messages out if it finds the system has hard locked. The short version
>>> is that you should add "nmi_watchdog=1" (no quotes) to the line in
>>> GRUB that has the kernel options. That assumes you have an APIC on the
>>> system. If that's not the case (you're on Uniprocessor, and no APIC)
>>> then you can try nmi_watchdog=2 instead. That'll only work on some
>>> systems, though.
>>>
>>> Better docs (than my cheesy writeup) are in
>>> Documentation/nmi_watchdog.txt in the kernel source distribution.
>>>     
>>
>> I was once told to add these to the kernel command line as well when
>> using NMI watchdog and they do seem to help it trigger more reliably:
>> "idle=poll nohz=off"
>
> Thank you to both Ray and Zan.  This was very helpful, and I think 
> that it has gotten me what I needed.
>
> "serial8250: too much work for irq16"
>
> Interestingly, now CTRL-SysRq-H will wake it back up... things get 
> running normally afterwards - the hard lock never occurs. 

After further troubleshooting it turns out that the message above was a 
bit of a red herring.  I moved the PCIe modem card from one PCIe slot to 
another so that it would be on a different IRQ (one that wasn't shared 
with the network, ATA, and USB).  The message above does not occur now, 
however, the hard lock is back... and this time with no kernel messages 
at all.

So, I'm back to square one again... I've got:

  nmi_watchdog=1 idle=poll nohz=off

... and still I get the hard lockup and no kernel messages.  How do I 
troubleshoot/debug this?  How do I know where to look?

Thanks,

Lee.
