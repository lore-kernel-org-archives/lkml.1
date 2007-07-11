Return-Path: <linux-kernel-owner+w=401wt.eu-S1764556AbXGKQFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764556AbXGKQFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 12:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755311AbXGKQFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 12:05:30 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1165 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778AbXGKQF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 12:05:29 -0400
Date: Wed, 11 Jul 2007 17:05:26 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Songmao Tian <tiansm@lemote.com>,
       LinuxBIOS Mailing List <linuxbios@linuxbios.org>, marc.jones@amd.com,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: about cs5536 interrupt ack
In-Reply-To: <4694FA7B.6030409@ru.mvista.com>
Message-ID: <Pine.LNX.4.64N.0707111653130.26459@blysk.ds.pg.gda.pl>
References: <4694A495.1050006@lemote.com> <Pine.LNX.4.64N.0707111347360.26459@blysk.ds.pg.gda.pl>
 <4694FA7B.6030409@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > does it return if you write 0xc to the address 0x20 in the I/O port space
> > and then read back from that location?  You should complain to the
> > manufacturer -- they may be able to fix the problem in a later revision.
> 
>    Haha, here's an excerpt form CS5535 spec. update:
> 
> 96. PIC does not support Polling mode
> 
> [...]
> 
> Implications: This mode is not normally used in x86 systems.
> Resolution: None.

 Yes, of course:

$ grep OCW3 arch/i386/kernel/*.c
arch/i386/kernel/time.c:		outb(0x0c, PIC_MASTER_OCW3);

not at all, indeed!

> > You can still dispatch interrupts manually by examining the IRR register,
> > but having a way to ask the 8259A's prioritiser would be nice.  Although
> > given such a lethal erratum you report I would not count on the prioritiser
> > to provide any useful flexibility...
> 
>    Why not? AMD just decided not to implement poll mode, that's all.

 If they have decided to skip such an "unimportant" bit of logic, they 
could have skipped more, only providing support for the basic FNM 
INT/INTA/EOI scheme -- the only one "architecturally" supported from the 
original IBM PC on.  And indeed, a brief look at the datasheed reveals 
they claim to have removed the SFNM too (which IMO provides a more 
reasonable nesting resolution and should be the default for setups where 
nesting is used, such as the environment as set up at the bootstrap by the 
PC BIOS).

  Maciej
