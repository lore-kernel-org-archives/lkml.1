Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYGZJ6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYGZJ6y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYGZJ6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:58:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47196 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbYGZJ6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:58:47 -0400
Date: Sat, 26 Jul 2008 11:58:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: rrichter@elbe.amd.com
Cc: Barry Kasindorf <barry.kasindorf@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH 10/24] x86/oprofile: Add IBS support for AMD CPUs, IBS
	buffer handling routines
Message-ID: <20080726095833.GE25890@elte.hu>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com> <1216753748-11261-11-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216753748-11261-11-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> @@ -272,7 +273,7 @@ static void increment_tail(struct oprofile_cpu_buffer *b)
>  {
>  	unsigned long new_tail = b->tail_pos + 1;
>  
> -	rmb();
> +	rmb();	/* be sure fifo pointers are synchromized */

ignore my previous mail :-)

> +	if (ibs_code == IBS_OP_BEGIN) {
> +	add_sample(cpu_buf, ibs[6], ibs[7]);
> +	add_sample(cpu_buf, ibs[8], ibs[9]);
> +	add_sample(cpu_buf, ibs[10], ibs[11]);
> +	}

style problem.

> +	int is_kernel = !user_mode(regs);
> +	unsigned long pc = profile_pc(regs);
> +
> +	struct oprofile_cpu_buffer *cpu_buf =
> +			 &per_cpu(cpu_buffer, smp_processor_id());

please dont put newlines in the middle of variable definitions.

>  /* transient events for the CPU buffer -> event buffer */
>  #define CPU_IS_KERNEL 1
>  #define CPU_TRACE_BEGIN 2
> +#define IBS_FETCH_BEGIN 3
> +#define IBS_OP_BEGIN    4

vertical alignment would help readability i guess. Plus use an enum 
instead of a macro.

	Ingo
