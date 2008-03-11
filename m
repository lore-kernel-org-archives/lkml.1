Return-Path: <linux-kernel-owner+w=401wt.eu-S1753290AbYCKJzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbYCKJzx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 05:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYCKJzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 05:55:44 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:6637 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbYCKJzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 05:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tK2UaiI+Cx/6Cv8OhAr+yUSZ8qgjctgfrALSg0u4KH3WQF5uH9WWKyQTzHaQhvpwEx9x4vB+XHYwT+u9vGs0v4CYQ8TE1Idc6eclI6wf+6MamNDvakMOl14ha4kwsCG7Vy5K6qo0+RtqUkD9MSSHoFE+2wJfUZnjx8lnmNCvxVw=
Message-ID: <df9815e70803110255s1c8323a8xf05b132ecc406bd0@mail.gmail.com>
Date: Tue, 11 Mar 2008 17:55:40 +0800
From: "Jike Song" <albcamus@gmail.com>
To: Chr <chunkeey@web.de>
Subject: Re: endless loop in native_flush_tlb_others in smp_64.c
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       venkatesh.pallipadi@intel.com, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, len.brown@intel.com
In-Reply-To: <200803102316.54457.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200803102316.54457.chunkeey@web.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC added

On Tue, Mar 11, 2008 at 6:16 AM, Chr <chunkeey@web.de> wrote:
> Hi,
Hi Chr,
>
>  ever since I moved to 2.6.25-rcY (Y should be between 2 and 5!).
>  I've seen several, but really hard-to-catch instant freezes on my
>  AMD64 Athlon X2 4200+ system...

Here I guess 2.6.24 is fine for you?

>
>  Most of them happend in X.org so at first I thought it had something to do
>  with the NVIDIA module... BUT, one time it froze "a way before" the module
>  could get loaded (and desynced my raid.......).
>
>  ---
>  SYSRQ-P revealed that the CPU were looping inside:
>
>  smp_64.c native_flush_tlb_others:
>  assembler code:
>  < 1ee:   f3 90                   pause
>  < 1f0:   f6 45 00 03             testb  $0x3,0x0(%rbp)
>  < 1f4:   75 f8                   jne    1ee <native_flush_tlb_others+0x5f>
>
>  also known as: (in C)
>
>  while (!cpus_empty(f->flush_cpumask))
>         cpu_relax();
>
>  So... has anyone a good idea what's happening here exactly? Or is there
>  already another topic or even a patch available?
>
>  Regards,
>         Chr.
>  --

Would you please attach your config file?  Do you have CONFIG_CPU_IDLE set?

Regards,
