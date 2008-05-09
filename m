Return-Path: <linux-kernel-owner+w=401wt.eu-S932273AbYEIQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbYEIQdT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYEIQc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:32:56 -0400
Received: from rtr.ca ([76.10.145.34]:1411 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765528AbYEIQcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:32:53 -0400
Message-ID: <48247CB3.5090800@rtr.ca>
Date: Fri, 09 May 2008 12:32:51 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Paul Mackerras <paulus@samba.org>,
       Josh Boyer <jwboyer@gmail.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Steven Rostedt <rostedt@goodmis.org>, tglx@linutronix.de,
       Len Brown <lenb@kernel.org>
Subject: Re: RFC: starting a kernel-testers group for newbies
References: <20080501113038.GW29330@cs181133002.pp.htv.fi> <20080430072013.7c3b30b1@infradead.org> <20080501132159.GC29330@cs181133002.pp.htv.fi> <18458.30641.838156.434563@cargo.ozlabs.ibm.com> <1209697815.2946.156.camel@vader.jdub.homelinux.org> <18458.37891.268060.691285@cargo.ozlabs.ibm.com> <20080502082936.GB2003@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805020750220.5994@woody.linux-foundation.org> <20080502154406.GA6545@beyonder.ift.unesp.br> <alpine.LFD.1.10.0805020859080.5994@woody.linux-foundation.org> <20080502171536.GA7041@beyonder.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEEFB8BF5@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEFB8BF5@orsmsx423.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pallipadi, Venkatesh wrote:
>  
> 
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org 
>> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of 
>> Carlos R. Mafra
>> Sent: Friday, May 02, 2008 10:16 AM
>> To: Linus Torvalds
>> Cc: Adrian Bunk; Paul Mackerras; Josh Boyer; Arjan van de Ven; 
>> Andrew Morton; Rafael J. Wysocki; davem@davemloft.net; 
>> linux-kernel@vger.kernel.org; jirislaby@gmail.com; Steven 
>> Rostedt; Pallipadi, Venkatesh
>> Subject: Re: RFC: starting a kernel-testers group for newbies
>>
>> On Fri  2.May'08 at  9:28:08 -0700, Linus Torvalds wrote:
>>
>>> Quite frankly, it does sound like the hang happens somewhere 
>> around the 
>>> 	hpet_init
>>> 	hpet_acpi_add
>>> 	hpet_resources
>>> 	hpet_resources: 0xfed00000 is busy
>>>
>>> printk's you added (correct?) and we've had tons of issues 
>> with NO_HZ, so 
>>> at a guess it is timer-related.
>> It happens a bit before that because when it hangs it doesn't 
>> print the above lines, and when it does not hang these lines are
>> the ones right after the point where it hangs. 
>>
>>> (And I assume it's stable if/once it gets past that boot hang issue? 
>> Yes you are right. When I have luck and the boot succeeds my 
>> Sony laptop
>> is rock solid and the kernel is wonderful (even the card 
>> reader works!).
>>
>>> That
>>> tends to mean that it's not some hardware instability, it's 
>> literally our 
>>> init code).
>> A few days ago I found this message in lkml in reply to a hpet patch
>> http://lkml.org/lkml/2007/5/7/361 in which the reporter also had 
>> a similar hang, which was cured by hpet=disable. 
>>
>> So it is in my TODO list to try to check out if that patch is 
>> in the current -git and whether it can be reverted somehow (I 
>> added Venki to the Cc: now)
>>
>> Thanks a lot for the answer!
> 
> It depends on whether we are HPET is being force detected based on the
> chipset or whether it was exported by the BIOS in ACPI table.
> 
> If it was force enabled and above patch is having any effect, then you
> should see a message like
>> Force enabled HPET at base address 0xfed00000
> 
> In any case, off late there seems to be quite a few breakages that are
> related to HPET/timer interrupts. One of them was on a system which has
> HPET being exported by BIOS
> http://bugzilla.kernel.org/show_bug.cgi?id=10409
> And the other one where we are force enabling based on chipset
> http://bugzilla.kernel.org/show_bug.cgi?id=10561
> 
> And then we have hangs once in a while reports by you, Roman and Mark
> here
> http://bugzilla.kernel.org/show_bug.cgi?id=10377
> http://bugzilla.kernel.org/show_bug.cgi?id=10117
..

Yeah.  This particular bug first appeared when NOHZ & HPET were added.
Somebody once suggested it had something to do with an SMI interrupt
happening in the midst of HPET calibration or some such thing.

But nobody who works on the HPET code has ever shown more than a casual
interest in helping to track down and fix whatever the problem is.

Cheers
