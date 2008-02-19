Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbYBSVH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYBSVH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:07:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYBSVHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:07:21 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56094 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbYBSVHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:07:20 -0500
Cc: Quel Qun <kelk1@comcast.net>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>
Message-Id: <895FB10F-5E5C-4409-AC3E-5F83BBF9ED72@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802181245370.7583@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v915)
Subject: Re: Kernel oops with bluetooth usb dongle
Date: Tue, 19 Feb 2008 22:07:15 +0100
References: <021820080001.29293.47B8CAD10009FD170000726D2207000953CE05040A05@comcast.net> <alpine.LFD.1.00.0802181245370.7583@apollo.tec.linutronix.de>
X-Mailer: Apple Mail (2.915)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

>>> Can you please enable CONFIG_SLUB_DEBUG=y and CONFIG_SLUB_DEBUG_ON=y
>>> and give it another try?
>>>
>>> If we can not catch it that way, I'll whip up a patch which points  
>>> us
>>> to the code which added the offending timer.
>>>
>> Hi,
>>
>> Note: I switched to 2.6.25-rc2. The only new thing I see is this  
>> message:
>>
>> hci_cmd_task: hci0 command tx timeout
>>
>> This comes from net/bluetooth/hci_core.c, line 1547
>>
>> There is indeed a timeout message in the log (at the end of this
>> email). I tried to boot with slub_debug but did not get anything
>> more. slabinfo -v does not report anything either.
>>
>> Crash log:
>>
>> hci_cmd_task: hci0 command tx timeout
>> BUG: unable to handle kernel paging request at 6b6b6b6b
>
> We got some more info ---------------------------^^^^^^^^
> #define POISON_FREE      0x6b    /* for use-after-free poisoning */
>
> So the timer is in an allocated data structure, which is
> freed without having removed the timer first.
>
>> Sorry for the meager yield.
>
> Hey, we know already more :)
>
> Marcel, any idea on this one ?

I don't really have any idea. Nothing has been changed in this area  
for a couple of years. The command TX timeout is the timeout that  
indicates a missing answer to a command sent down to the Bluetooth chip.

However this involves some atomic and tasklet stuff. Did we have some  
changes that I missed and might now render this usage as broken.

Regards

Marcel


