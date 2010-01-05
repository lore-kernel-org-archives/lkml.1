Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256Ab0AEJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab0AEJEe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 04:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868Ab0AEJEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 04:04:33 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:35968 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0AEJE3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 04:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nws820z5bCvmcMS/BKOusJn404uNnkqjruDBiOMv7bNGtDuSxrJBxgIzHdz9OHIBN9
         3R3nqYATKWtHf/ebOWRbv8hEU8ClRtFtDwy3sxuojqFxsjy2WV3QkDvfytOSSc7UReXq
         CYsh5veyQUbT9r1Fh1AxdprNbvxewoPwJIewA=
MIME-Version: 1.0
In-Reply-To: <4B4273D6.2010306@kernel.org>
References: <daef60381001030705r93b3fbfkc50e7b9bbc62b334@mail.gmail.com> 
	<4B411F14.1040302@kernel.org> <20100103150134.5bdab023@infradead.org> 
	<4B412341.2010002@kernel.org> <20100103151406.20228c3a@infradead.org> 
	<daef60381001040822q188d7374te5a177c5f9877ac2@mail.gmail.com> 
	<4B4273D6.2010306@kernel.org>
From: Hui Zhu <teawater@gmail.com>
Date: Tue, 5 Jan 2010 17:04:07 +0800
Message-ID: <daef60381001050104u5d4adf11k16bec2406501fbd2@mail.gmail.com>
Subject: Re: [PATCH] stack2core: show stack message and convert it to core 
	file when kernel die
To: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       saeed bishara <saeed.bishara@gmail.com>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Nicolas Pitre <nico@fluxnic.net>, Ralf Baechle <ralf@linux-mips.org>,
       David Daney <ddaney@caviumnetworks.com>,
       Tomaso Paoletti <tpaoletti@caviumnetworks.com>,
       Chris Dearman <chris@mips.com>,
       Paul Gortmaker <Paul.Gortmaker@windriver.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Coly Li <coly.li@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I agree with read the current stack message is better.

About the extending, I have some question with it:
1.  markup_oops.pl have itself idea, it try use dmesg| markup_oops.pl
show what happen to usr.  This is different with s2c.
I am not sure people like it have other function with it.  Too much
part of this file need to be change.  It need rewrite, just the oops
message parse part can be keep.

2.  I use perl to work in a long time before, I know it good at parse
the text, but I am not sure it good at handle struct like:
struct mips64_elf_prstatus
{
	struct s2c_elf_siginfo	pr_info;
	uint16_t		pr_cursig;
	uint64_t		pr_sigpend;
	uint64_t		pr_sighold;
	uint32_t		pr_pid;
	uint32_t		pr_ppid;
	uint32_t		pr_pgrp;
	uint32_t		pr_sid;
	struct s2c_timeval_64	pr_utime;
	struct s2c_timeval_64	pr_stime;
	struct s2c_timeval_64	pr_cutime;
	struct s2c_timeval_64	pr_cstime;

	uint64_t		pr_reg[45];

	uint32_t		pr_fpvalid;
} __attribute__ ((aligned(8)));
Even if what happen, I will keep a c s2c with myself.  :)

Best regards,
Hui

On Tue, Jan 5, 2010 at 07:03, Tejun Heo <tj@kernel.org> wrote:
> Hello,
>
> On 01/05/2010 01:22 AM, Hui Zhu wrote:
>> For the s2c, user just "s2c < message >core" It did everything with itself.
>> After that, gdb vmlinux core.
>
> It is true that by making the kernel oops message more verbose, s2c
> can be made way simpler.  However, dependence on standard object tools
> or perl is already assumed and avoiding it doesn't really buy
> anything.  I really like the idea but unfortunately I'm doubtful that
> it will be able to go upstream in the current form.  The suggested
> solution (extending markup_oops.pl) won't be too much work, most of
> functionality will remain the same and will have much higher chance of
> getting included.
>
> Thanks.
>
> --
> tejun
>
