Return-Path: <linux-kernel-owner+w=401wt.eu-S1751078AbZIVSbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751078AbZIVSbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 14:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbZIVSbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 14:31:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:53231 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZIVSbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 14:31:31 -0400
Date: Tue, 22 Sep 2009 20:31:44 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: pradeep hettiarachchi <pacprnt@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Intel Local APIC behavior on low frequencies
Message-ID: <20090922203144.5f3694d6@infradead.org>
In-Reply-To: <8fe204b0909220931j5925938ft5bec2adf19513f5a@mail.gmail.com>
References: <8fe204b0909220931j5925938ft5bec2adf19513f5a@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 12:31:24 -0400
pradeep hettiarachchi <pacprnt@gmail.com> wrote:

> Hi,
> 
> Here’s a description of my problem. It would be great if you can find
> some info on this matter.
> 
> 
> 
> I need to find some information about local APIC and CPU frequency
> scaling behavior.  Currently I am modifying  the Linux kernel for my
> research, which involves studying a custom job scheduler I am
> developing at different CPU frequencies.  As we know, if the kernel
> works in tick-less mode (and in hi resolution mode) it uses the local
> APIC as a clock event device and as the clock tick device.
> 
> 
> 
> My working environment is: Linux vanilla kernel 2.6.24, Intel core 2
> Quad Q6600, Intel core 2 duo T6500 processors. Gcc compiler and the
> tool chain.
> 
> The information I am trying to find is:
> 
> 1) I want to find-out the tick count(say for a 100 ms period) of the
> local APIC when the CPU operates at different operating frequencies.
> When I study this matter, I found that the local APIC does not tick
> (does not work accurately) reliably as the clock frequency is varied.
> It works accurately in the maximum frequency of the system. Do you
> know any reason for that? or it is the way it operates?(is that
> normal?)
> 
> (my observation: when I count the LAPIC tick count for the maximum CPU
> frequency, it matches with the number of ticks that the system
> generates at the time of the initial LAPIC calibration, which happens
> at the very beginning of the kernel initialization; however when I try
> to count the number of ticks with scaled frequencies, the LAPIC
> "current counter" difference is very less, some times less than 100
> for 100 ms, which should not be true.)
> 
> I don't have good reason to think that, some other task re-programs
> the LAPIC: I set the LAPIC "initial counter" to a huge value, further
> I assume when the system works in hi resolution mode, the re-program
> happens from the LAPIC handler "hrtimer_interrupt" which I replace
> with a dummy handler.
> 
> Thank you in advance.

the local apic timer is not impacted by the cpu frequency. HOWEVER,
it will stop when the CPU is idle.
