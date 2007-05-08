Return-Path: <linux-kernel-owner+w=401wt.eu-S967480AbXEHS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967480AbXEHS1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 14:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966692AbXEHS1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 14:27:42 -0400
Received: from terminus.zytor.com ([192.83.249.54]:46107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966632AbXEHS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 14:27:41 -0400
Message-ID: <4640C115.6080300@zytor.com>
Date: Tue, 08 May 2007 11:27:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexander van Heukelum <heukelum@mailshack.com>, Andi Kleen <ak@suse.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
References: <20070505104452.GA30944@mailshack.com>	<20070508032817.e4734798.akpm@linux-foundation.org>	<46405E0C.3020909@zytor.com> <20070508111243.13e7a7f7.akpm@linux-foundation.org>
In-Reply-To: <20070508111243.13e7a7f7.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> Without patch:
> 
> (gdb)  x/20i _start
> 0x0 <_start>:   ljmpw  $0x0,$0x8
> 0x6 <_start+6>: rolb   $0x8c,(%edi)
> 0x9 <start2+1>: enter  $0xd88e,$0x8e
> 0xd <start2+5>: rorb   $0xfb,0x7c00bcd0(%esi)
> 0x14 <start2+12>:       cld    
> 0x15 <start2+13>:       mov    $0x20ac0031,%esi
> 0x1a <msg_loop+2>:      (bad)  
> 0x1b <msg_loop+3>:      je     0x26 <die>
> 0x1d <msg_loop+5>:      mov    $0xe,%ah
> 0x1f <msg_loop+7>:      mov    $0x10cd0007,%ebx
> 0x24 <msg_loop+12>:     jmp    0x18 <msg_loop>
> 0x26 <die>:     xor    %eax,%eax
> 0x28 <die+2>:   int    $0x16
> 
> With patch:
> 
> (gdb) x/20i _start
> 0x0 <_start>:   ljmp   $0xc88c,$0x7c00005
> 0x7 <start2+2>: mov    %eax,%ds
> 0x9 <start2+4>: mov    %eax,%es
> 0xb <start2+6>: mov    %eax,%ss
> 0xd <start2+8>: mov    $0xfcfb7c00,%esp
> 0x12 <start2+13>:       mov    $0x20ac002e,%esi
> 0x17 <msg_loop+2>:      (bad)  
> 0x18 <msg_loop+3>:      je     0x23 <die>
> 0x1a <msg_loop+5>:      mov    $0xe,%ah
> 0x1c <msg_loop+7>:      mov    $0x10cd0007,%ebx
> 0x21 <msg_loop+12>:     jmp    0x15 <msg_loop>
> 
> not sure what's going on there.  We seem to have confused gdb.
> 

You're trying to disassemble 16-bit code as if it was 32-bit code.  The
easiest way to disassemble is to have NASM installed on your machine and
just do:

	ndisasm bzImage

My setup code rewrite creates an intermediate .elf file to retain
debugging information and make 16-bit disassembly
("objdump -d -m i8086") easier.

	-hpa
