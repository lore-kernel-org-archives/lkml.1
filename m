Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZGUCDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZGUCDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 22:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbZGUCDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 22:03:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:48524 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZGUCDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 22:03:32 -0400
Message-ID: <4A652198.3030200@windriver.com>
Date: Mon, 20 Jul 2009 21:02:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 01/10] ehci early_printk: split ehci debug driver from
 early_printk.c
References: <1248120392-8372-1-git-send-email-jason.wessel@windriver.com> <1248120392-8372-2-git-send-email-jason.wessel@windriver.com> <4A650786.1030501@kernel.org> <4A651FCB.6080704@windriver.com>
In-Reply-To: <4A651FCB.6080704@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jul 2009 02:01:43.0937 (UTC) FILETIME=[322B5710:01CA09A7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Yinghai Lu wrote:
>   
>> Jason Wessel wrote:
>>   
>>     
>>> Move the dbgp early printk driver in advance of refactoring and adding
>>> new code, so the changes to this code are tracked separately from the
>>> move of the code.
>>>
>>> The drivers/usb/early directory will be the location of the current
>>> and future early usb code for driving usb devices prior initializing
>>> the standard interrupt driven USB drivers.
>>>
>>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>>> Cc: Greg KH <gregkh@suse.de>
>>> Cc: Ingo Molnar <mingo@elte.hu>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Yinghai Lu <yinghai@kernel.org>
>>> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
>>> ---
>>>  arch/x86/kernel/early_printk.c |  715 ---------------------------------------
>>>  drivers/usb/Makefile           |    1 +
>>>  drivers/usb/early/Makefile     |    5 +
>>>  drivers/usb/early/ehci-dbgp.c  |  723 ++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/usb/ehci_def.h   |    6 +
>>>  5 files changed, 735 insertions(+), 715 deletions(-)
>>>  create mode 100644 drivers/usb/early/Makefile
>>>  create mode 100644 drivers/usb/early/ehci-dbgp.c
>>>     
>>>       
>> before this patch, we could use dbgp without compiling USB susbsystem in...
>>
>>   
>>     
>
> And you shouldn't need it today.  You pointed out an error in the patch
> which I will correct.  The drivers/Makefile needs to be changed, instead
> of the drivers/usb/Makefile.
>
> The dbgp code was changed in the patch series such that it works with or
> with out the usb subsystem and with or without the earlyconsole=keep,...
>
> All the code in the drivers/usb/early would work this way as well.  As
> an example, I have an experimental UHCI serial driver that can be used
> via the earlyprintk.
>
>
>   
So I checked into this further because I was curious how all the tests
passed. 

The drivers/usb/Makefile is read because of the line in drivers/Makefile

     67 obj-$(CONFIG_PCI)               += usb/

That of course will cause the drivers/usb/early/Makefile to get read. 
This explains why all the testing passed.  For now it might be ok, but
it will have to get changed to compile the dbgp driver when/if the dbgp
gets changed to work with a non-pci EHCI controller.

Jason.

