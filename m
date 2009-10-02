Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZJBKoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZJBKoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757561AbZJBKoC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:44:02 -0400
Received: from isrv.corpit.ru ([81.13.33.159]:58865 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753767AbZJBKoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:44:01 -0400
Message-ID: <4AC5D972.70002@msgid.tls.msk.ru>
Date: Fri, 02 Oct 2009 14:44:02 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: LZMA on PIII-Celeron is broken [was: 2.6.31: booting on a PIII Celeron?]
References: <4AC0D59F.8000502@msgid.tls.msk.ru> <4AC0D651.7030009@msgid.tls.msk.ru> <20090928163617.GA25503@atrey.karlin.mff.cuni.cz> <4AC20CD0.8030801@msgid.tls.msk.ru> <20090929160312.GA14405@elf.ucw.cz>
In-Reply-To: <20090929160312.GA14405@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>>> So the celeron machine lacks "apic" flag.  And in my
>>>> kernel config, apic is enabled:
>>>>  CONFIG_X86_LOCAL_APIC=y
>>>>  CONFIG_X86_IO_APIC=y
>>>> (but not on the command line like apic=force)
>>> try 'noapic nolapic' to see if it helps?
>> Neither (nor both) changes anything.  It just reboots
>> instantly right after "Loading initrd..." message from
>> the bootloader.
> 
> Ok, you may want to try bisection...
> 
>> Ok, one more thing to mention.  2.6.31 introduced a
>> somewhat annoying feature, -- the screen (console)
>> blinks at the very start of the boot process (I mean
>> text mode, no any framebuffers or the like).  Here,
>> the screen blinks as usual for .31, I can see everything
>> back including that "Loading initrd" line, and only
>> after this the system reboots.  No more messages
>> gets printed, including "kernel command line:",
>> "Initializing cgroup subsys" or "Linux version ...".
>> I switched CPU clock to 200MHz (minimum clock rate
>> this motherboard supports using jumpers) and I can
>> see the whole thing like in slow motion.
> 
> Hmm, can you try enabling earlyprintk?

The issue was simpler than we thought.  It's the
lzma code that causes this.  In this .config I
changed from BZIP2 compression to LZMA compression.
When changing it back to BZIP2 the system boots
again.

Now I've no idea how to debug it further, since
there should be no difference between "plain"
PIII and PIII-Celeron.

Thanks!

/mjt
