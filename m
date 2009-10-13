Return-Path: <linux-kernel-owner+w=401wt.eu-S933706AbZJMR6C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933706AbZJMR6C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:58:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbZJMR6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:58:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60627 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151AbZJMR6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:58:00 -0400
Message-ID: <4AD4BF23.4060604@zytor.com>
Date: Tue, 13 Oct 2009 10:55:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86: unify sys_iopl
References: <4ABD3EC2.1020104@goop.org> <20091013103044.GA3915@elte.hu> <4AD4A9AE.10306@zytor.com> <4AD4B0A0.6050200@goop.org>
In-Reply-To: <4AD4B0A0.6050200@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2009 09:53 AM, Jeremy Fitzhardinge wrote:
> On 10/13/09 09:24, H. Peter Anvin wrote:
>> First of all, the unification looks good.
>>
>> As far as .32 is concerned... this *is* a bug even if this is only for
>> paravirt, and given the small amount of code I am personally OK with
>> taking the whole patch for .32.
>>
>> However, the patch is not complete!  The patch incidentally eliminates
>> the need to have assembly stubs for sys_iopl, and those assembly stubs
>> should be removed.  I have a patch for that currently test building.
>>   
> 
> I wasn't sure whether task_pt_regs() needed the full register set to be
> saved to correctly return rflags (that is, does PTREGSCALL change the
> shape of the stack, or just the contents?).
> 

A double-check confirmed my previous statement: on 64 bits, PTREGSCALL
does populate the fields at the beginning of struct pt_regs, but
task_pt_regs(current) is valid even without those fields populated,
since it is anchored at the top "hanging down" from the kernel entry
stack pointer address.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

