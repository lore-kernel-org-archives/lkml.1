Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab0BHUvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:51:10 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36090 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0BHUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:51:08 -0500
Date: Mon, 8 Feb 2010 21:51:05 +0100
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100208205105.GA16990@rhlx01.hs-esslingen.de>
References: <20100206142141.GA12871@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002061534020.2811@localhost.localdomain> <20100207191949.GA23665@rhlx01.hs-esslingen.de> <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain> <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 08, 2010 at 09:40:24PM +0100, Thomas Gleixner wrote:
> On Mon, 8 Feb 2010, Thomas Gleixner wrote:
> > On Mon, 8 Feb 2010, Andreas Mohr wrote:
> > Which compiler version are you using ?
> > 
> > Can you please provide the disassembly of kernel/time/timekeeping.o ?
> 
> Is that NMI watchdog hit fully reproducible ?

Looks like it:
- another bootup also had lockup message
- all /var/log/dmesg* have lockup message, oldest is:
2010-02-07 20:00 dmesg.4.gz

Linux version 2.6.33-rc6 (root@note) (gcc version 4.3.4 (Debian 4.3.4-6)) #3 Sun Jan 31 23:47:51 CET 2010
.
.
.
PM: Adding info for No Bus:cooling_device0
Switching to clocksource acpi_pm
BUG: NMI Watchdog detected LOCKUP on CPU0, ip c1046694, registers:
Modules linked in:

Pid: 266, comm: kwatchdog Not tainted 2.6.33-rc6 #3 Inspiron 8000
/Inspiron 8000
EIP: 0060:[<c1046694>] EFLAGS: 00000082 CPU: 0
EIP is at timekeeping_forward_now+0xf0/0x11d
EAX: 342100fe EBX: f3dcdfc8 ECX: 63826cfb EDX: ffffffff
ESI: 003ffd7b EDI: 00000000 EBP: dfa31f50 ESP: dfa31f28
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process kwatchdog (pid: 266, ti=dfa31000 task=dfa4e0a0 task.ti=dfa31000)
Stack:
 005b9e7e 00000000 6184c590 00000fff 002cb338 4b6f0da7 00000000 c13d8524
<0> c13d8524 dfa31f48 dfa31f60 c10466d2 c13d8524 c13d8524 dfa31f6c
c104725e


IOW, it's NOT gcc 4.4 and it's pretty darn reproducible.

Andreas Mohr
