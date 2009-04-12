Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbZDLSDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbZDLSDF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZDLSCx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:02:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41146 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbZDLSCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:02:52 -0400
Date: Sun, 12 Apr 2009 20:02:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: hpa@zytor.com, tglx@linutronix.de, xemul@openvz.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, macro@linux-mips.org, andi@firstfloor.org
Subject: Re: [rfc 0/4] x86 - apic dummy ops with cleanups
Message-ID: <20090412180239.GA3489@elte.hu>
References: <20090412164738.967602112@openvz.org> <20090412172431.GA26459@elte.hu> <20090412180014.GD6942@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412180014.GD6942@lenovo>
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


* Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Thanks, Ingo!
> 
> Actually I found one a bit suspicious thing (not sure if it was 
> initially designed to behave like that).
> 
> Suppose we have SMP compiled kernel and even supported on HW level 
> but then we disable apic thru kernel option. And then when system 
> startup it should be working fine since we go to uniprocessor 
> mode. Then the machine going for reboot and we have:
> 
> Starting from arch/x86/kernel/reboot.c
> 
> native_machine_shutdown
> 	smp_send_stop
> 		smp_ops.smp_send_stop
> 			native_smp_send_stop
> 				disable_local_APIC
> 					apic_write(APIC_SPIV, value);
> 
> Since we have reserved APIC memory mapped area (in _anycase_) it 
> doesn't cause any problems but was it initially supposed?

i dont think that was supposed so. If the APIC wasnt even enabled 
then we shouldnt try to disable it. Note that there are a few 
unusual paths to APIC enablement: for example by twiddling the 
nmi_watchdog knob in /proc/sys - or in theory through a CPU hotplug 
event.

	Ingo
