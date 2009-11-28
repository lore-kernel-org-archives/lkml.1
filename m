Return-Path: <linux-kernel-owner+w=401wt.eu-S1752294AbZK1PfP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbZK1PfP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 10:35:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbZK1PfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 10:35:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbZK1PfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 10:35:13 -0500
Subject: Re: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Breuer <mbreuer@majjas.com>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Arjan van de Ven <arjan@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091128071808.GA32183@elte.hu>
References: <4B106CC0.4050406@majjas.com>  <20091128071808.GA32183@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 28 Nov 2009 16:27:46 +0100
Message-ID: <1259422066.2155.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-28 at 08:18 +0100, Ingo Molnar wrote:
> * Michael Breuer <mbreuer@majjas.com> wrote:
> 
> > Having given up for now on VT-D, I rebooted 2.6.38 rc8 with 
> > intel_iommu=off. Whilst my myriad of broken bios issues cleared, I now 
> > see in perf top acpi_os_read_port as continually the busiest function. 
> > With intel_iommu enabled, _spin_lock was always on top, and nothing 
> > else was notable.
> > 
> > This seems odd to me, perhaps this will make sense to someone else.
> > 
> > FWIW, I'm running on an Asus p6t deluxe v2; ht enabled; no errors or 
> > oddities in dmesg or /var/log/messages.
> 
> Could you post the perf top output please?
> 
> Also, could you also post the output of:
> 
> 	perf stat -a --repeat 10 sleep 1
> 
> this will show us how idle the system is. (My guess is that your system 
> is idle and perf top shows acpi_os_read_port because the system goes to 
> idle via ACPI methods and PIO is slow. In that case all is nominal and 
> your system is fine. But it's hard to tell without more details.)

Isn't there also a list of symbols it won't display? Can't find either
the list nor the switch to turn it off (really didn't look hard), but
acme might know.



