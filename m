Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbYB0Azw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbYB0Azw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756877AbYB0Azl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:55:41 -0500
Received: from web52909.mail.re2.yahoo.com ([206.190.49.19]:31918 "HELO
	web52909.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756695AbYB0Azk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:55:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=47yD/wRv8ARYpil3lNiXbtKnGaiIE2tu6Eys20+Y7yvZmbtLIEAu1eRD6mqwV48q5WLrqJjfAgf6gnoh/zTZOLS5RMKhHlFUy/lR5GrLIC/mOMuR+faRjtD2NqkpWzbJ5W+wwVQSQ9kKuf+3v/zdWsOO+l7dNl9aVEHtwV/fdIE=;
X-YMail-OSG: iubazHAVM1kU3O4bNYZIyEgSUWZITXhbMamuGqSMaXC3b6nNYJAcG73QrxGUx9CRLg--
Date: Wed, 27 Feb 2008 00:55:38 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: Linux 2.6.24.1  - kernel does not boot; IRQ trouble?
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080226234025.GC14117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <91946.43854.qm@web52909.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Greg KH <greg@kroah.com> wrote:
> On Tue, Feb 26, 2008 at 10:36:00PM +0000, Chris Rankin wrote:
> > FYI, this hang still exists in 2.6.24.3 and so I am still needing to boot with the acpi=noirq
> > parameter.
> 
> You're going to have to refresh my memory.  Was this a problem caused by
> the .1 .2 or .3 kernel releases?  Did 2.6.24 have this problem as well,
> or was it ok?

It's a bug introduced in 2.6.24; that ACPI fails to allocate IRQs correctly for PCI devices, which
makes the kernel hang at boot-time:

PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
BUG: NMI Watchdog detected LOCKUP on CPU0, eip c0102b07, registers:
Modules linked in:

Pid: 0, comm: swapper Not tainted (2.6.24.1 #1)
EIP: 0060:[<c0102b07>] EFLAGS: 00000246 CPU: 0
EIP is at default_idle+0x2f/0x43
EAX: 00000000 EBX: c0102ad8 ECX: 010b2000 EDX: fffedb3c
ESI: 00000000 EDI: c1409284 EBP: c0323fb4 ESP: c0323fb4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process swapper (pid: 0, ti=c0323000 task=c02fc320 task.ti=c0323000)
Stack: c0323fc4 c01025af c140c000 c0357284 c0323fcc c02873a9 c0323ff8 c032792f 
       00000037 c0327108 00000000 00000004 00009000 c0343b00 00000002 00099800 
       c0319000 007ab007 00000000 
Call Trace:
 [<c0105020>] show_trace_log_lvl+0x1a/0x2f
 [<c01050d2>] show_stack_log_lvl+0x9d/0xa5
 [<c010517d>] show_registers+0xa3/0x1df
 [<c0105ba7>] die_nmi+0x81/0xd2
 [<c0115d72>] nmi_watchdog_tick+0xd5/0x12a
 [<c0105f19>] do_nmi+0x93/0x24b
 [<c0289b83>] nmi_stack_correct+0x26/0x2b
 [<c01025af>] cpu_idle+0x9a/0xcf
 [<c02873a9>] rest_init+0x5d/0x5f
 [<c032792f>] start_kernel+0x2e2/0x2ea
 [<00000000>] _stext+0x3feff000/0x19
 =======================
Code: 36 c0 00 55 89 e5 75 33 80 3d e5 17 32 c0 00 74 2a 89 e0 25 00 f0 ff ff 83 60 0c fd f0 83 04
24 00 fa 8b 40 08 a8 04 75 04 fb f4 <eb> 01 fb 89 e0 25 00 f0 ff ff 83 48 0c 02 eb 02 f3 90 5d c3
55 

(This trace is from 2.6.24.1, but it hasn't changed in 2.6.24.3.) I currently avoid this problem
by booting with acpi=noirq, which puts all the PCI devices on IRQ 9 instead of sharing them
between IRQs 16, 17, 18 and 19.

Cheers,
Chris



      __________________________________________________________
Sent from Yahoo! Mail.
A Smarter Inbox. http://uk.docs.yahoo.com/nowyoucan.html
