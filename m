Return-Path: <linux-kernel-owner+w=401wt.eu-S1761017AbYFHCFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761017AbYFHCFT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 22:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757577AbYFHCFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 22:05:06 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:52985
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757557AbYFHCFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 22:05:05 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUBAHbaSkh8qNvt/2dsb2JhbAAIrhU
X-IronPort-AV: E=Sophos;i="4.27,606,1204470000"; 
   d="scan'208";a="326948250"
Subject: Re: bcm33xx port
From: Ben Nizette <bn@niasdigital.com>
To: Luke -Jr <luke@dashjr.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200806072019.42108.luke@dashjr.org>
References: <200806072019.42108.luke@dashjr.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Sun, 08 Jun 2008 12:04:58 +1000
Message-Id: <1212890698.4089.17.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-07 at 20:19 -0500, Luke -Jr wrote:
> I am working on a port for the bcm33xx platform, which includes a MIPS CPU:
> 	http://wiki.openwrt.org/BroadcomBCM33xxPort
> 
> However, I seem to be hitting problems with memory allocation, as 
> load_elf_binary is segfaulting inside padzero/__bzero.

Seems to have issues way before that ;-)

> 
> This is my first attempt at real Linux kernel development, so if anyone could 
> throw me pointers on how I would approach debugging and fixing this problem, 
> I'd really appreciate it. (boot log with early printk is attached)

I'm not too up on MIPS but there're a few things in the log which stand
out to me:

Determined physical RAM map:
 memory: 00fa0000 @ 00000000 (usable)
User-defined physical RAM map:
 memory: 007a1200 @ 00000000 (usable)

Can you confirm these sizes and locations for RAM?  Does anything change
if you don't force the size constraint?

CPU frequency 32.00 MHz

Really?  Is your bootloader setting the CPU up correctly before handing
control to Linux?

irq 8: nobody cared (try booting with the "irqpoll" option)

What's on IRQ8, should anyone care at this early stage?  Did the
bootloader enable this (should it)?

Reserved instruction in kernel code[#1]:

You're compiling with an appropriate -march switch?

Good luck :-)
	--Ben.
