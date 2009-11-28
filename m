Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbZK1LAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbZK1LAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 06:00:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZK1LAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 06:00:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855AbZK1LAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 06:00:52 -0500
Date: Sat, 28 Nov 2009 08:18:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Breuer <mbreuer@majjas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
Message-ID: <20091128071808.GA32183@elte.hu>
References: <4B106CC0.4050406@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B106CC0.4050406@majjas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Michael Breuer <mbreuer@majjas.com> wrote:

> Having given up for now on VT-D, I rebooted 2.6.38 rc8 with 
> intel_iommu=off. Whilst my myriad of broken bios issues cleared, I now 
> see in perf top acpi_os_read_port as continually the busiest function. 
> With intel_iommu enabled, _spin_lock was always on top, and nothing 
> else was notable.
> 
> This seems odd to me, perhaps this will make sense to someone else.
> 
> FWIW, I'm running on an Asus p6t deluxe v2; ht enabled; no errors or 
> oddities in dmesg or /var/log/messages.

Could you post the perf top output please?

Also, could you also post the output of:

	perf stat -a --repeat 10 sleep 1

this will show us how idle the system is. (My guess is that your system 
is idle and perf top shows acpi_os_read_port because the system goes to 
idle via ACPI methods and PIO is slow. In that case all is nominal and 
your system is fine. But it's hard to tell without more details.)

Thanks,

	Ingo
