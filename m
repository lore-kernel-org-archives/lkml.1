Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651AbZIWVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbZIWVXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751043AbZIWVXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:23:15 -0400
Received: from mail.windriver.com ([147.11.1.11]:50420 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbZIWVXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:23:14 -0400
Message-ID: <4ABA90C6.3000600@windriver.com>
Date: Wed, 23 Sep 2009 16:19:02 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>, Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [origin tree boot hang] [PATCH] Revert "early_printk: Allowmorethan
 one early console"
References: <20090923135539.GA6542@kroah.com> <20090923173709.GA18056@elte.hu> <4ABA6182.1000106@windriver.com> <20090923190239.GC24251@elte.hu> <20090923191756.GA25163@elte.hu> <20090923210555.GA13492@elte.hu>
In-Reply-To: <20090923210555.GA13492@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2009 21:19:05.0848 (UTC) FILETIME=[7B360F80:01CA3C93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>
>   
>> The commit point to which the attached config and bootlog belongs is:
>>
>>   2.6.31-07863-gb64ada6
>>
>> Reverting:
>>
>>   c953094: early_printk: Allow more than one early console
>>
>> solves it.
>>     
>
> btw., the boot options are:
>
> Command line: root=/dev/sda6 earlyprintk=serial,ttyS0,115200 console=ttyS0,115200 debug
> initcall_debug apic=verbose sysrq_always_enabled ignore_loglevel 
> selinux=0 nmi_watchdog=0 panic=1 3
>
>   

AH HA!

earlyprintk=serial,ttyS0,115200

You are invoking the same device twice which is why you are having infinite recursion.  It was not obvious to me why the earlyprintk code would allow "serial" or "ttyS", but perhaps we need to protect for that?

Your boot line should be:

earlyprintk=serial,115200

OR

earlyprintk=ttyS0,115200

The line you had there before would have been the equivalent of doing:

earlyprintk=ttyS0,ttyS0,115200

Given this, do we still need to execute the revert your revert?  Or perhaps do we need to add some protection?

Thanks,
Jason.

