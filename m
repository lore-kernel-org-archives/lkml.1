Return-Path: <linux-kernel-owner+w=401wt.eu-S1757956AbYIPSD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956AbYIPSD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 14:03:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbYIPSDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 14:03:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49612 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbYIPSDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 14:03:45 -0400
Message-ID: <48CFF4EB.1050401@zytor.com>
Date: Tue, 16 Sep 2008 11:03:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux@sandersweb.net
CC: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86: Don't use NOPL on 32-bit cpu's because not all systems
 support it.
References: <200809161159.15870.linux@sandersweb.net> <48CFDF82.3000704@zytor.com> <200809161348.24130.linux@sandersweb.net>
In-Reply-To: <200809161348.24130.linux@sandersweb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I think you still want the nopl enabled for 64-bits.
> 

Yes.  Accordingly, I didn't change 64 bits.

> int main()
> {
> 	signal(SIGILL, except);
> 	asm("\n"
> 		"mov $0x01, %eax\n" /* function number */
> 		".byte 0x0f, 0x3f, 0x07, 0x0b\n" /* call VPC */
> 	   );
> 	printf("Inside Virtual PC\n");
> 	return 0;
> }

Well, isn't that "interesting".  0F 3F is in the range expected 
(although not documented) to be used for 3-byte opcode prefixes in the 
future.  It's also the Centaur ALTINST instruction (which I believe have 
to be enabled via an MSR, so in that way it's not a bad choice.)

It's definitely less broken than the official way to detect VMWare, but 
still pretty daft.  (CPUID, MSR or PCI IDs make a lot more sense.)

The "official" way to detect Virtual PC is apparently to look for 
"Microsoft Corportation" as the DMI motherboard manufacturer.  This is 
downright dangerously stupid, since Microsoft likes to make false starts 
in the hardware business on a regular basis, and doesn't work with old 
Connectix VPC anyway.  However, there is supposedly "Virtual Machine" as 
the model, which can be used to disambiguate.

	-hpa
