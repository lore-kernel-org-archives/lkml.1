Return-Path: <linux-kernel-owner+w=401wt.eu-S1762500AbZEHFWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762500AbZEHFWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 01:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbZEHFWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 01:22:13 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:10094 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZEHFWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 01:22:12 -0400
Date: Fri, 08 May 2009 01:21:46 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: regression in TSC unstable?
In-reply-to: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
Message-id: <alpine.LFD.2.00.0905080117410.4710@localhost.localdomain>
References: <alpine.DEB.2.00.0905072359530.28378@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Steven Rostedt wrote:

> The ring-buffer-benchmark module creates a producer and consumer and loops 
> on do_gettimeofday until it hits about 10 seconds. Then it calculates the 
> number of events recorded / time running.
> 
> After Ingo merged Linus's latest

merged what into what?
are you referring to the upstream kernel or something else?

> my tests when from 330ns per entry to 
> 880ns. After bisecting it I came down to this change:
> 
>    commit a71e4917dc0ebbcb5a0ecb7ca3486643c1c9a6e2
>    Author: Len Brown <len.brown@intel.com>
>    Date:   Tue Apr 21 00:50:11 2009 -0400
> 
>     ACPI: idle: mark_tsc_unstable() at init-time, not run-time
> 
> 
> I've never had a problem with the TSC with this box before. It passes the 
> synchronization phase, and until this commit, the TSC never was marked as 
> unstable.
> 
> Should it now be unstable? Or is this a false positive?

If you revert that patch the issue goes away?

Does your Xeon even export any C-states?
(cat /proc/acpi/processor/*/power)

does your dmesg before or afer the patch actually print
"TSC halts in idle"?

thanks,
-Len

> # cat /proc/cpuinfo 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 4
> model name	: Intel(R) Xeon(TM) CPU 2.80GHz
> stepping	: 1
> cpu MHz		: 2793.272
> cache size	: 1024 KB
> physical id	: 0
> siblings	: 2
> core id		: 0
> cpu cores	: 1
> apicid		: 0
> initial apicid	: 0
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 5
> wp		: yes
> flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca 
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
> lm constant_tsc pebs bts pni dtes64 monitor ds_cpl cid cx16 xtpr
> bogomips	: 5586.54
> clflush size	: 64
> cache_alignment	: 128
> address sizes	: 36 bits physical, 48 bits virtual
> power management:
> 
> Anything else I might need to know?
> 
> -- Steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
