Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbYETTBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbYETTBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757629AbYETTBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:01:45 -0400
Received: from mailout01.t-online.de ([194.25.134.80]:41735 "EHLO
	mailout01.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbYETTBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:01:44 -0400
Message-ID: <48331FFF.5070300@t-online.de>
Date: Tue, 20 May 2008 21:01:19 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080503)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <4829326A.6060808@t-online.de>	<19f34abd0805122347x4d9c5d03m16679d724189790e@mail.gmail.com>	<4829D345.7020909@t-online.de>	<19f34abd0805140034j75d97ecbw5a03c200645768cb@mail.gmail.com>	<482B1BD2.8040400@t-online.de>	<19f34abd0805141017g26c13e96t2e7edc23bec263d0@mail.gmail.com>	<20080514183558.40178fe5@core>	<48306DCA.9070108@t-online.de> <20080518185104.0a539f25@core>
In-Reply-To: <20080518185104.0a539f25@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: ZY+HOEZfZhKxjBL6A3XCqr6ym32r3YSKtkWcz6DSUCwKYN-HGMeK7RbCzQUaqRxZwx
X-TOI-MSGID: f1809f45-7535-42b1-9cc6-50c513d4ccf5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> This GDB was configured as "x86_64-linux-gnu"...
>> Attaching to program: /var/tmp/coreutils-6.10/coreutils-6.10/src/stty, process 26465
>> /tmp/buildd/gdb-6.8/gdb/linux-nat.c:988: internal-error: linux_nat_attach: Assertion `pid == GET_PID (inferior_ptid) && WIFSTOPPED (status) && WSTOPSIG (status) == SIGSTOP' failed.
>> A problem internal to GDB has been detected,
> 
> So your gdb is broken, your stty is doign stuff nobody else seems to be
> seeing ? My first thought is to suspect the distro/source as I've still
> had no other equivalent reports and given the gdb spew.
> 

I doubt that Debian is to blame here. I get the same with native
gdb-6.8 and native coreutils-6.10:

# /usr/local/stow/gdb-6.8/bin/gdb ./stty 11944
GNU gdb 6.8
Copyright (C) 2008 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-unknown-linux-gnu"...
Attaching to program: /var/tmp/coreutils-6.10/coreutils-6.10/src/stty, process 11944
../../gdb/linux-nat.c:988: internal-error: linux_nat_attach: Assertion `pid == GET_PID (inferior_ptid) && WIFSTOPPED (status) && WSTOPSIG (status) == SIGSTOP' failed.
A problem internal to GDB has been detected,
further debugging may prove unreliable.
Quit this debugging session? (y or n) y

../../gdb/linux-nat.c:988: internal-error: linux_nat_attach: Assertion `pid == GET_PID (inferior_ptid) && WIFSTOPPED (status) && WSTOPSIG (status) == SIGSTOP' failed.
A problem internal to GDB has been detected,
further debugging may prove unreliable.
Create a core file of GDB? (y or n) n


> I'll have a dig further however as the GDB spew itself might actually be
> a useful clue. Not sure I can do much without a proper trace however (if
> gdb is borked on your box is strace giving sane reports ?)
> 

As written earlier in this thread I can attach strace to the running
stty. It prints a continuous flow of

:
ioctl(0, SNDCTL_TMR_START or TCSETS, {B38400 opost isig icanon echo ...}) = ? ERESTARTSYS (To be restarted)
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
:

Using strace -v I get

:
ioctl(0, SNDCTL_TMR_START or TCSETS, {c_iflags=0x500, c_oflags=0x5, c_cflags=0xbf, c_lflags=0x8a3b, c_line=0, c_cc="\x03\x1c\x7f\x15\x04\x00\x01\x00\x11\x13\x1a\x00\x12\x0f\x17\x16\x00\x00\x00"}) = ? ERESTARTSYS (To be restarted)
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
--- SIGTTOU (Stopped (tty output)) @ 0 (0) ---
:


Surely I am no specialist for termio. Please mail if I can help.
BTW, I am on 2.6.25.4 now.


Regards

Harri
