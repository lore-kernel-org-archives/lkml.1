Return-Path: <linux-kernel-owner+w=401wt.eu-S1759807AbZDLAI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759807AbZDLAI5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 20:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZDLAIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 20:08:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39734 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbZDLAIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 20:08:45 -0400
Date: Sat, 11 Apr 2009 20:06:05 -0400
From: Dave Jones <davej@redhat.com>
To: akpm@linux-foundation.org
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       efault@gmx.de, len.brown@intel.com, mingo@elte.hu,
       rusty@rustcorp.com.au, tglx@linutronix.de,
       venkatesh.pallipadi@intel.com, yakui.zhao@intel.com,
       yanmin_zhang@linux.intel.com
Subject: Re: [patch for 2.6.30 2/2]
	arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c: avoid cross-CPU
	interrupts
Message-ID: <20090412000605.GA23869@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, akpm@linux-foundation.org,
	lenb@kernel.org, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, efault@gmx.de, len.brown@intel.com,
	mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de,
	venkatesh.pallipadi@intel.com, yakui.zhao@intel.com,
	yanmin_zhang@linux.intel.com
References: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904110617.n3B6HJ7W026502@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 11:17:18PM -0700, Andrew Morton wrote:
 > From: Andrew Morton <akpm@linux-foundation.org>
 > 
 > In drv_read(), check to see whether we can run the rdmsr() on the current
 > CPU.  If so, do that.  So smp_call_function_single() can avoid the IPI.

Wouldn't it be a better to make smp_call_function_single do this check
itself, so all callers benefit from this optimisation?

*looks*

Wait, won't this already be caught by this code in smp_call_function_single() ?

286         this_cpu = get_cpu();
...
291         if (cpu == this_cpu) {
292                 local_irq_save(flags);
293                 func(info);
294                 local_irq_restore(flags);
295         } else {



	Dave 

