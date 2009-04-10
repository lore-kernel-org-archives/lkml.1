Return-Path: <linux-kernel-owner+w=401wt.eu-S939127AbZDJRUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939127AbZDJRUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938944AbZDJRUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:20:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53229 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765248AbZDJRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:20:07 -0400
Message-ID: <49DF7FA4.9070909@zytor.com>
Date: Fri, 10 Apr 2009 10:19:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@linux.intel.com, rjw@sisk.pl, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --	infrastructure
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz>
In-Reply-To: <20090410080444.GC16512@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> 
>> +	.code16
>> +	.text
>> +	.globl	intcall
>> +	.type	intcall, @function
>> +intcall:
>> +	/* Self-modify the INT instruction.  Ugly, but works. */
>> +	cmpb	%al, 3f
>> +	je	1f
>> +	movb	%al, 3f
>> +	jmp	1f		/* Synchronize pipeline */
>> +1:
> 
> There are various CPU bugs with self-modifying code, but I guess we
> are not using it heavily enough. Also we are single-threaded so that
> should be ok.
> 								Pavel
> 

This case is extremely straightforward, so I'm not worried about it. 
The final JMP is actually not required (there is a LOOP instruction 
between the modify and the invocation point) but is there for extra safety.

FWIW, we already do SMC during the transfer to protected mode 
(pmjump.S), and hopefully got the issues worked out there.

	-hpa
