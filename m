Return-Path: <linux-kernel-owner+w=401wt.eu-S1765314AbXGKPUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765314AbXGKPUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 11:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760264AbXGKPUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 11:20:33 -0400
Received: from h155.mvista.com ([63.81.120.155]:25911 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759926AbXGKPUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 11:20:32 -0400
Message-ID: <4694F5B8.50009@ru.mvista.com>
Date: Wed, 11 Jul 2007 19:22:32 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Songmao Tian <tiansm@lemote.com>
Cc: linuxbios@linuxbios.org, marc.jones@amd.com, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: about cs5536 interrupt ack
References: <4694A495.1050006@lemote.com>
In-Reply-To: <4694A495.1050006@lemote.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Songmao Tian wrote:
> Hi,

>    I am trying to use a mips cpu the cs5536. I have some problem with 
> the 8259 of cs5536.  The  databook said,

    Which databook?

> "Control Logic
> The INT output goes directly to the CPU interrupt input.
> When an INT signal is activated, the CPU responds with an
> Interrupt Acknowledge access that is translated to two
> pulses on the INTA input of the PIC. At the first INTA pulse,
> the highest priority IRR bit is loaded into the corresponding
> ISR bit, and that IRR bit is reset. The second INTA pulse
> instructs the PIC to present the 8-bit vector of the interrupt
> handler onto the data bus."

> Is it the responsibility of north bridge to reponse to intr with a PCI 
> Interrupt Ack cycle?



> it's a problem that my northbridge didn't implement that! Fortunately we 
> use a fpga as a northbridge.

    Wait, CS5536 is a nortbridge itself!

> it seem it's no way to fix this by software, for OCW3 didn't implemnt 
> Poll command:(

    Quite a few 8259 clones don't.

> so I guess the the process is:
> 1) 8259 receive a int, a bit irr got set.
> 2) 8259 assert intr.
> 3) northbrige generate a int ack cycle.

    To what, PCI?

> 4) cs5536 translate the ack into two INTA pulse, and the reponse 

    Nonsense. It would only make sense to translate INTA cycles from CPU bus 
to the PCI bus, not the other way around.

> northbridge with a interrupt vector.

    As I said, CS5536 is northbridge in itself.

> 5) then my program can get the vector from northbridge?

    It's CPU that gets the vector, your program could only do this using poll 
comand which as

> Is that right?

    No.

> Without int ack, generic linux-mips 8259 code can't work.

   I'm compleetly lost here -- what does CS5536 has to do with MIPS?

> Greetings,
> Tian

WBR, Sergei
