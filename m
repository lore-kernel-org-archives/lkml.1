Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbZIXTPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbZIXTPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 15:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZIXTP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 15:15:29 -0400
Received: from mx09.lb01.inode.at ([62.99.145.9]:58462 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753599AbZIXTP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 15:15:28 -0400
X-Greylist: delayed 3210 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Sep 2009 15:15:27 EDT
Message-ID: <4ABBC54E.6090209@sbg.ac.at>
Date: Thu, 24 Sep 2009 21:15:26 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.23 (X11/20090826)
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: linux-kernel@vger.kernel.org, alexander.huemer@sbg.ac.at
Subject: Re: 2.6.{30,31} x86_64 ahci problem - irq 23: nobody cared
References: <4ABBB8C2.2080901@sbg.ac.at> <4ABBBB01.1050600@caviumnetworks.com>
In-Reply-To: <4ABBBB01.1050600@caviumnetworks.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney wrote:
> Alexander Huemer wrote:
>> the problem appears under heavy system load and slows down the system to
>> unusable speed.
>> kernels before .30 were not affected.
>> irqpoll does not change behavior.
>>
>> error message from .31:
>>
>>     [157152.418524] irq 23: nobody cared (try booting with the "irqpoll"
>>     option)
>>     [157152.418530] Pid: 1359, comm: cc1plus Tainted: G        W 
>
> Right here is the problem  ->         ^^^^^^^^
>
> Haven't you read all the threads about the evil of C++.  This is just
> one more example of the why we shouldn't be using it. :-)
>
> David Daney
>
>>     2.6.31-gentoo-blackbit #2
>>     [157152.418532] Call Trace:
>>     [157152.418534]  <IRQ>  [<ffffffff81066e3f>] ?
>>     __report_bad_irq+0x30/0x7d
>>     [157152.418544]  [<ffffffff81066f93>] ? note_interrupt+0x107/0x170
>>     [157152.418547]  [<ffffffff81067580>] ? handle_fasteoi_irq+0x8a/0xaa
>>     [157152.418551]  [<ffffffff8100d1cf>] ? handle_irq+0x17/0x1d
>>     [157152.418554]  [<ffffffff8100c84b>] ? do_IRQ+0x54/0xb2
>>     [157152.418558]  [<ffffffff8100b6d3>] ? ret_from_intr+0x0/0xa
>>     [157152.418559]  <EOI>
>>     [157152.418560] handlers:
>>     [157152.418562] [<ffffffff813d2a6f>] (ahci_interrupt+0x0/0x426)
>>     [157152.418566] Disabling IRQ #23
>>
>>
>> bios of the machine is up to date,
>> i tried all related bios settings, no change.
>>
>> kernel config for .31    
>> http://xx.vu/~ahuemer/config_ahuemer_20090923.gz
>> lspci -vxxx               http://xx.vu/~ahuemer/lspci_ahuemer_20090923
>> lsusb -v                  http://xx.vu/~ahuemer/lsusb_ahuemer_20090923
>> /proc/interrupts        
>> http://xx.vu/~ahuemer/proc_interrupts_ahuemer_20090923
>> thread in gentoo forums 
>> http://forums.gentoo.org/viewtopic-t-780725-start-0.html
>>
>> please tell me what additional info is needed.
>> please CC me on replies, i am not subscribed.
>>
>> -alex
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
thanks for your quick answer, david.
so, this isn't a kernel issue at all ?
imho a user process shouldn't be able to cause such a situation.
what can i do against that phenomenon ?

-alex
