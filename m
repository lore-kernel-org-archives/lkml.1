Return-Path: <linux-kernel-owner+w=401wt.eu-S1759275AbXELOVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759275AbXELOVs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:21:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754949AbXELOVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:21:42 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45810 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbXELOVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:21:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexander van Heukelum <heukelum@mailshack.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@osdl.org>,
       Matt Domsch <Matt_Domsch@dell.com>, Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com>
	<1178806235.18785.1189115515@webmail.messagingengine.com>
	<46435F8A.1040203@zytor.com> <20070510220406.GA21110@mailshack.com>
	<4643A128.30302@zytor.com> <20070512122137.GA25944@mailshack.com>
Date: Sat, 12 May 2007 08:20:52 -0600
In-Reply-To: <20070512122137.GA25944@mailshack.com> (Alexander van Heukelum's
	message of "Sat, 12 May 2007 14:21:37 +0200")
Message-ID: <m1r6pmqg1n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum <heukelum@mailshack.com> writes:

> On Thu, May 10, 2007 at 03:48:08PM -0700, H. Peter Anvin wrote:

> I can confirm that it works for at least one computer over here (a six
> months old x86_64 machine with ATI ES1000-based on-board graphics). Some
> non-vesa modes including a nice 100x30 one with 8x16 font are found by
> the 'scan' option. No 100x60, however, but that is not a regression.
>
>> > I thought the 32-bit jump was required to come before the segment loads.
>> > Does this code load values from the gdt, or are they just loaded as real
>> > mode segments? As long as it does not crash it does not matter, because
>> > head.S reloads them again.
>> 
>> Once CR0.PE is set, segments are loaded from the GDT.
>
> I believe you :).

HPA is both right and wrong on this.  The safe sequence for entering
protected mode requires a jump immediately after setting PE in %cr0.
To serialize the instruction stream and to be on an execution that
is tested and guaranteed to work in cpus.

On a lot of processors you can get away with more then that, but
Intel at least explicitly states in their "Software Developers Manual
Volume 3: System Programming" in 9.9.1 "Switching to Protected Mode"
that you need the jump immediately following enabling PE in cr0.

So while I was debugging and instrumenting code I would happily
place an instruction before the jump so I could get output.
However in production grade code I would not place anything
between the setting of PE in cr0 and the first jump instruction.

Eric
