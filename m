Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZHKM3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZHKM3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:29:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbZHKM3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:29:05 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40910 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbZHKM3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:29:04 -0400
Date: Tue, 11 Aug 2009 12:52:02 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Thomas Gleixner <tglx@linutronix.de>
cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>, Fra@jasper.es
Subject: Re: [ANNOUNCE] 2.6.29.6-rt23
In-Reply-To: <alpine.LFD.2.00.0907102023500.2768@localhost.localdomain>
Message-ID: <alpine.LSU.2.00.0908111140280.5036@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>  <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>  <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>  <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain> 
 <alpine.LFD. <alpine.LFD.2.00.0907102023500.2768@localhost.localdomain>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Friday 2009-07-10 20:29, Thomas Gleixner wrote:
>On Fri, 10 Jul 2009, Fernando Lopez-Lezcano wrote:
>> On Thu, 2009-07-09 at 20:25 +0200, Thomas Gleixner wrote:
>> 
>> I'm getting slightly weird behavior from rt23 in an intel quad core
>> machine (my T61 laptop is fine), rt22 was fine. It is some timer issue,
>> if I type continuously I get (every few seconds) repeated keys. Nothing
>> in the logs, nothing in dmesg that is (significantly) different from an
>> rt22 boot. 

I am getting the same issue, reliably reproducibly - though ironically
only with the proprietary NVIDIA. Key repeats, screen going "No signal"
for a sec, sometimes comes back, sometimes hangs the whole machine.

nv is fine, as is tty1 with or without NVIDIA.

>Hmm. The only change which touches timer related stuff is the ktime*
>speedups. Can you please apply the revert patch below and check
>whether that changes anything? If not, then we need to look at the
>2.6.29.5 -> .6 delta.
>
>diff --git b/kernel/time/timekeeping.c a/kernel/time/timekeeping.c
>index 4c99c98..3192dd0 100644
>--- b/kernel/time/timekeeping.c
>+++ a/kernel/time/timekeeping.c

This 2nd part (timekeeping.c) of your patch unfortunately does not
apply on -rt23, but I have edited it manually to get a result.

Works ok so far.

(BTW, CONFIG_GENERIC_TIME=y).

