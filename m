Return-Path: <linux-kernel-owner+w=401wt.eu-S1030760AbXEDPqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030760AbXEDPqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 11:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030780AbXEDPqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 11:46:04 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:35021 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030760AbXEDPqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 11:46:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>
	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>
	<m13b2csjeg.fsf@ebiederm.dsl.xmission.com> <463B508A.2030307@goop.org>
Date: Fri, 04 May 2007 09:45:43 -0600
In-Reply-To: <463B508A.2030307@goop.org> (Jeremy Fitzhardinge's message of
	"Fri, 04 May 2007 08:26:02 -0700")
Message-ID: <m1vef8r3rs.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Eric W. Biederman wrote:
>> Using 0x40 as a stack would be ok.
>>   
>
> OK.
>
>> There are issues with CONFIG_RELOCATABLE and V!=P that I'm not
>> comfortable with yet, because we can't tell the difference.
>
> But it doesn't matter in this case, does it?  It just needs to find the
> current address, whether it be virtual or physical, of the bss.  It
> doesn't assume any particular offset.

For the bss that sounds correct.

> When does the relocation happen?   Does the bzImage loader do it as part
> of decompression?  Or does the kernel do it to itself?  (Not that it
> makes any difference here.)

Currently right after compression just before we jump to startup_32.
But if the usage of vmlinux continues to increase we should really
move it to just after startup_32.  Which is where we run into problems
with supporting virtual addresses at our normal kernel entry point.

The relocation doesn't live just after startup_32 now because it is
hard to put there.

The practical challenge is that we need to compute the delta between
where we are at and where we were compiled for, and with possibility of
virtual address and physical address I don't know how we would compute
where we are at, in a way we could compare to our compile time physical
or virtual addresses.

Xen when it comes it at a completely isolated entry point is fine
because there is no pretence of code reuse, and we don't have to auto-detect
how we were started.

Eric
