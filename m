Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbXGKJnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbXGKJnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbXGKJnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:43:08 -0400
Received: from [222.92.8.141] ([222.92.8.141]:35495 "HELO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1759070AbXGKJnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:43:06 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jul 2007 05:43:06 EDT
Message-ID: <4694A495.1050006@lemote.com>
Date: Wed, 11 Jul 2007 17:36:21 +0800
From: Songmao Tian <tiansm@lemote.com>
User-Agent: Icedove 1.5.0.8 (X11/20061116)
MIME-Version: 1.0
To: LinuxBIOS Mailing List <linuxbios@linuxbios.org>, marc.jones@amd.com,
       linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: about cs5536 interrupt ack
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    I am trying to use a mips cpu the cs5536. I have some problem with 
the 8259 of cs5536.  The  databook said,

"Control Logic
The INT output goes directly to the CPU interrupt input.
When an INT signal is activated, the CPU responds with an
Interrupt Acknowledge access that is translated to two
pulses on the INTA input of the PIC. At the first INTA pulse,
the highest priority IRR bit is loaded into the corresponding
ISR bit, and that IRR bit is reset. The second INTA pulse
instructs the PIC to present the 8-bit vector of the interrupt
handler onto the data bus."

Is it the responsibility of north bridge to reponse to intr with a PCI 
Interrupt Ack cycle?
it's a problem that my northbridge didn't implement that! Fortunately we 
use a fpga as a northbridge.

it seem it's no way to fix this by software, for OCW3 didn't implemnt 
Poll command:(

so I guess the the process is:
1) 8259 receive a int, a bit irr got set.
2) 8259 assert intr.
3) northbrige generate a int ack cycle.
4) cs5536 translate the ack into two INTA pulse, and the reponse 
northbridge with a interrupt vector.
5) then my program can get the vector from northbridge?

Is that right?

Without int ack, generic linux-mips 8259 code can't work.

Greetings,
Tian



