Return-Path: <linux-kernel-owner+w=401wt.eu-S1756635AbYGaSBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbYGaSBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYGaSBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:01:15 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:47290 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587AbYGaSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=vDG5Bw8BQDG3ycVBBR4Xl8qn9Q0AODfEL9jTarXrDtKa/XDh0NiK86r565/iJFDRwh
         yyKqdyukrZTDS/2bbQIfx24Wzl6mdA6/fIzaFmeBlwhymmnyjm6vBZ+S8YY8iuv+6MWs
         7Sgr0mJLUJZY8pPsMOcqVVJTwnkXhfeUkuG+4=
Message-ID: <c4e36d110807311101h4fea377dsb4470c0935bbd419@mail.gmail.com>
Date: Thu, 31 Jul 2008 20:01:12 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: Sysrq+B doesn't work on my box
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080731143905.GF19665@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110807310645n3ff6e61j17414433c5aee030@mail.gmail.com>
	 <20080731143905.GF19665@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/31 Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> On Thu, 31 Jul 2008, Zdenek Kabelac wrote:
>> I'd like to get resolved this problem - my T61 machine doesn't reboot
>> with SysRQ+B key.
>> And I never remember if it was ever rebooting.
>>
>> This is all I know so far and I've no idea where could be the problem.
>
> Well, many of the different ThinkPad BIOSes are really sensitive to the
> proper boot/reboot/shutdown sequence (whatever it is).  Otherwise, the thing
> gets stuck in SMBIOS limbo and hung.  For exeample, we had major issues with
> boxes that only shut down half-way and ended up draining the cells to
> critical levels, a few months ago.  I don't know what finally fixed THAT
> one, but it was ugly.
>
> Here is another example: you can't get the TCO watchdog to reboot all (any?)
> thinkpads properly on hardware.  In my T43, the TCO watchdog IS hooked to
> something, but the BIOS hates it to trip and the entire box goes to
> neverland when it fires...
>
> If sysrq+b uses a different reboot path than the normal reboot path, it is
> the first hint of what is missing...

I've spend some time with tracking this issue more - and I've discovered this:

SysRQ+B  doesn't work with right AltGr on my keyboard - but it does
work with the left Alt which I'm not normally using (It's somewhat
easier to use the right one)
Any idea why AltGR+SysRQ+b does not work on T61 ?

Blocking reboot goes through the arch/x86/kernel/reboot.c
native_machine_emergency_restart()  case BOOT_KBD:  (10 loop outb()
iteration)
and ends in case BOOT_TRIPLE:  int3 - there it stays forever - during
the press of poweroff button it even visits that sysrq __handler.

if the kernel is started with   init=/bin/sh  - boot works without
problems - so it looks like that disabling reboot capability is the
result of Fedora's  rc.sysinit process.
Yet I've no idea what that could be....

Zdenek
