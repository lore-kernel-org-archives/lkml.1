Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbYIRTfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbYIRTfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754997AbYIRTex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:34:53 -0400
Received: from gw.goop.org ([64.81.55.164]:54393 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929AbYIRTex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:34:53 -0400
Message-ID: <48D2AD5E.7040602@goop.org>
Date: Thu, 18 Sep 2008 12:34:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ferenc Wagner <wferi@niif.hu>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: doubled idle count
References: <87vdwtfxng.fsf@tac.ki.iif.hu>
In-Reply-To: <87vdwtfxng.fsf@tac.ki.iif.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ferenc Wagner wrote:
> Hi,
>
> After upgrading a Xen virtual machine to Debian's 2.6.26-4 kernel, I
> noticed that the idle counter doubled its pace on one of the machines:
>
> service2:~# yes >/dev/null &
> [1] 32578
> service2:~# grep cpu0 /proc/stat; sleep 1; grep cpu0 /proc/stat
> cpu0 141208 9113 57273 13379659 61012 0 792 2350 0
> cpu0 141310 9113 57274 13379659 61012 0 792 2350 0
> service2:~# fg
> yes > /dev/null
> ^C
> service2:~# grep cpu0 /proc/stat; sleep 1; grep cpu0 /proc/stat
> cpu0 141952 9113 57277 13383481 61012 0 792 2350 0
> cpu0 141953 9113 57278 13383681 61012 0 792 2350 0
>   

Sorry, could you be clearer here?  What are we looking at?

> One out of three machines show this effect, with the exact same kernel
> and Xen versions (3.2.0, dom0 is Debian's stock Etch 2.6.18 kernel).
> They aren't hosted by the same machine, though: the misbehaving one is
> on a different installation with very similar hardware (3 vs 2 GHz).
> All the guest are paravirtual.
>   

So you're saying that they are identical Xen and guest kernel binaries,
but one of three is showing doubled idle time?

That seems unlikely.  The source of that time is from Xen itself, and I
think it should be hardware independent, though I guess its possible
there's something going on at in the Xen-level timekeeping.

That said, I think there's some chance that stolen time may get counted
as idle time.  Does the one machine with a different outcome have
something else running in another virtual machine (including dom0)?

    J

> service2:~# cat /proc/cpuinfo 
> processor	: 0
> vendor_id	: GenuineIntel
> cpu family	: 15
> model		: 2
> model name	: Intel(R) Xeon(TM) CPU 3.06GHz
> stepping	: 5
> cpu MHz		: 3056.482
> cache size	: 1024 KB
> physical id	: 0
> siblings	: 1
> core id		: 0
> cpu cores	: 1
> apicid		: 1
> initial apicid	: 1
> fdiv_bug	: no
> hlt_bug		: no
> f00f_bug	: no
> coma_bug	: no
> fpu		: yes
> fpu_exception	: yes
> cpuid level	: 2
> wp		: yes
> flags		: fpu de tsc msr pae cx8 cmov pat pse36 clflush dts mmx fxsr sse sse2 ss ht pbe up pebs bts cid xtpr
> bogomips	: 6128.11
> clflush size	: 64
> power management:
>
> I don't know what else would be useful, please ask.
>   

