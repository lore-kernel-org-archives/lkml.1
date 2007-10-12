Return-Path: <linux-kernel-owner+w=401wt.eu-S1759004AbXJLUap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004AbXJLUap (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756431AbXJLUag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:30:36 -0400
Received: from maxwell.spina.si ([193.77.104.223]:57712 "EHLO maxwell.spina.si"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbXJLUag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:30:36 -0400
Message-ID: <470FD96A.8040505@kanardia.eu>
Date: Fri, 12 Oct 2007 22:30:34 +0200
From: Rok Markovic <kernel@kanardia.eu>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 2.6.23-rt1 lockup after loading HAL deamon
References: <470F27DA.9020307@kanardia.eu> <20071012083551.GA17937@elte.hu> <470FB4F4.60707@kanardia.eu> <20071012175831.GA27420@elte.hu>
In-Reply-To: <20071012175831.GA27420@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I enabled netconsole but I am affraid that it won't help. In attachment
I am sending complete log over netconsole. While I was trying to make
everything, I got a lockup on linux-2.6.23-rc8, but I am not sure into
this. But all lockups happend in VGA console mode. Any ideas.

Rok


Ingo Molnar wrote:
>> I tried to recompile with those options enabled, kernel and linux 
>> boots and loads fine, but after few minutes (if i try to recompile 
>> kernel in console) the system locks completely (hard reset) without 
>> any messages. Is there anything I can do, maybe console on serial 
>> port? My new config is atached.
> 
> yes, serial console (or netconsole) output would be useful, if you can 
> solve that. Another way would be to boot with nmi_watchdog=2, do the 
> kernel recompile in a VGA text console, and wait for the lockup to 
> occur. Either you get some crash message to the text console 
> immediately, or you should get the NMI watchdog print something within a 
> minute or so. If neither happens you just get a blank hard lockup then 
> the wedge is very deep ...
> 
> (also make sure that the NMI counter in /proc/interrupts is increasing 
> on all CPUs properly, with nmi_watchdog=2. If not all CPUs/cores are 
> increasing their NMI counters once per second then the NMI watchdog wont 
> be able to print out a stackdump.)
> 
> 	Ingo

