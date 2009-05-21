Return-Path: <linux-kernel-owner+w=401wt.eu-S1751200AbZEUFDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751200AbZEUFDc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 01:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbZEUFDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 01:03:25 -0400
Received: from ns.netcenter.hu ([195.228.254.57]:52943 "EHLO mail.netcenter.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbZEUFDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 01:03:24 -0400
X-Greylist: delayed 742 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 May 2009 01:03:23 EDT
Message-ID: <013501c9d9cf$161a74a0$0400a8c0@dcccs>
From: "Janos Haar" <janos.haar@netcenter.hu>
To: <paulmck@linux.vnet.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
References: <030101c9d92f$d0668600$0400a8c0@dcccs> <20090521025037.GD6839@linux.vnet.ibm.com>
Subject: Re: Fw: RCU detected CPU 1 stall (t=4295904002/751 jiffies) Pid:902, comm: md1_raid5
Date: Thu, 21 May 2009 06:46:15 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

Thank you for your attention.
Yes, the PC makes 2-3 second "pauses" and drop this message again and again.
If i remove the RCU debugging, the message disappears, but the pauses still 
here, and makes 2-3 load on the idle system.
Can i do something?
You suggest to use PREEMPT? (This is a server.)

Thank you,
Janos Haar

----- Original Message ----- 
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Janos Haar" <djani22@netcenter.hu>
Cc: <linux-kernel@vger.kernel.org>
Sent: Thursday, May 21, 2009 4:50 AM
Subject: Re: Fw: RCU detected CPU 1 stall (t=4295904002/751 jiffies) 
Pid:902, comm: md1_raid5


> On Wed, May 20, 2009 at 11:46:07AM +0200, Janos Haar wrote:
>> Hello list,
>>
>> Somebody know, what is this?
>> May 17 23:12:13 gladiator-afth1 kernel: RCU detected CPU 1 stall
>> (t=4295904002/751 jiffies)
>> May 17 23:12:13 gladiator-afth1 kernel: Pid: 902, comm: md1_raid5 Not
>> tainted 2.6.28.10 #1
>> May 17 23:12:13 gladiator-afth1 kernel: Call Trace:
>> May 17 23:12:13 gladiator-afth1 kernel:  <IRQ>  [<ffffffff80265395>] ?
>> get_timestamp+0x9/0xf
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8026854f>]
>> __rcu_pending+0x64/0x1e2
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff80268703>]
>> rcu_pending+0x36/0x6f
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8023f546>]
>> update_process_times+0x37/0x5f
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff802504a7>]
>> tick_periodic+0x6e/0x7a
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff802504d4>]
>> tick_handle_periodic+0x21/0x65
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8021ad60>]
>> smp_apic_timer_interrupt+0x8f/0xad
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff8020bf1b>]
>> apic_timer_interrupt+0x6b/0x70
>> May 17 23:12:13 gladiator-afth1 kernel:  <EOI>  [<ffffffff80820b8f>] ?
>> _spin_unlock_irqrestore+0x13/0x17
>
> One of the following functions is looping in the kernel.  If you are
> running with HZ=250, it has been looping for about three seconds.
> Interrupts are enabled, but preemption must be disabled (perhaps due
> to !CONFIG_PREEMPT).
>
> Thanx, Paul
>
>> May 17 23:12:13 gladiator-afth1 kernel:  [<ffffffff80728720>] ?
>> bitmap_daemon_work+0x142/0x3b0
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80724c58>] ?
>> md_check_recovery+0x1b/0x45b
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8071976c>] ?
>> raid5d+0x5d/0x503
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80726533>] ?
>> md_thread+0xd5/0xed
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80248e4a>] ?
>> autoremove_wake_function+0x0/0x38
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8072645e>] ?
>> md_thread+0x0/0xed
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80248d3b>] ?
>> kthread+0x49/0x76
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8020c169>] ?
>> child_rip+0xa/0x11
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff80248cf2>] ?
>> kthread+0x0/0x76
>> May 17 23:12:18 gladiator-afth1 kernel:  [<ffffffff8020c15f>] ?
>> child_rip+0x0/0x11
>> Neilbrown from the RAID list suggested to ask someone else...(The mail is
>> below.)Thanks,Janos Haar----- Original Message ----- From: "Janos Haar"
>> <janos.haar@netcenter.hu>
>> To: "Neil Brown" <neilb@suse.de>
>> Cc: <linux-raid@vger.kernel.org>
>> Sent: Tuesday, May 19, 2009 12:30 PM
>> Subject: Re: RCU detected CPU 1 stall (t=4295904002/751 jiffies) Pid: 
>> 902,
>> comm: md1_raid5
>>
>>
>>>
>>> ----- Original Message ----- From: "Neil Brown" <neilb@suse.de>
>>> To: "Janos Haar" <janos.haar@netcenter.hu>
>>> Cc: <linux-raid@vger.kernel.org>
>>> Sent: Tuesday, May 19, 2009 3:05 AM
>>> Subject: Re: RCU detected CPU 1 stall (t=4295904002/751 jiffies) Pid: 
>>> 902,
>>> comm: md1_raid5
>>>
>>>
>>>> On Tuesday May 19, janos.haar@netcenter.hu wrote:
>>>>> Hello list, Neil,
>>>>>
>>>>> Somebody can say something about this issue?
>>>>> I am not surprised, if it is hardware related, but this is on a brand
>>>>> new
>>>>> server, so i am looking for a solution... :-)
>>>>> May 17 23:12:13 gladiator-afth1 kernel: RCU detected CPU 1 stall
>>>>> (t=4295904002/751 jiffies)
>>>>
>>>> I have no idea what this means.
>>>> I've occasionally seen this sort of message in early boot then the
>>>> system continued to work perfectly so I figured it was an early-boot
>>>> glitch.  I suggest asking someone who understands RCU.
>>>>
>>>>>
>>>>> The entire log is here:
>>>>> http://download.netcenter.hu/bughunt/20090518/messages
>>>>>
>>>>> The system is on the md1, and working, but slowly.
>>>>
>>>> How slowly?  Is the slowness due to disk throughput?
>>>
>>> No no, this is a fresh and idle server.
>>> I have configured the disks, raid on another PC, and when it finished, i
>>> have copy up the known good, pre-installed sw pack with old 2.6.18.
>>> This pack is good, tested on many times, and this reports too this issue
>>> on this machine. (first)
>>> I have compiled the 2.6.28.10 on it, it takes about 6 hour! 8-/
>>> But the 2.6.28.10 reports this too.
>>>
>>> The slowness is not disk based, i think, on idle time if i move the
>>> selector line in mc, this stopps too for some seconds or i can't type in
>>> bash when this happens, and another one RCU message comes to the log...
>>> (It happens periodically, independently of i am doing something or not.)
>>>
>>> I am not sure, it is raid related or not, but the kernel reports only 
>>> the
>>> md1_raid5 pid, not another one.
>>> This is why i am asking here first.
>>>
>>> Thanks anyway. :-)
>>>
>>>> Have you tested the individual drives and compared that with the
>>>> array?
>>>
>>> This is a brand new hw, with 4x500GB samsung drive, wich reports no
>>> problem at all by smart.
>>>
>>>>
>>>>
>>>>> If i left the server for 1 day,  it will crash without a saved log.
>>>>
>>>> This is a concern!  It usually points to some sort of hardware
>>>> problem, but it is very hard to trace.
>>>> Is the power supply rated high enough to support all devices?
>>>
>>> I am using 550W good quality new PS, and the PC uses only 55-65W,
>>> measured. ;-)
>>> (1x core2duo, 4x hdd, nothing more interesting)
>>>
>>>> I cannot think of anything else to suggest .. except start swapping
>>>> components until the problem goes away...
>>>
>>> In this way, i need to start with the motherboard. 8-(
>>>
>>> Thanks a lot,
>>> Janos Haar
>>>
>>>>
>>>> NeilBrown
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/ 

