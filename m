Return-Path: <linux-kernel-owner+w=401wt.eu-S1753165AbZK1Roi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753165AbZK1Roi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 12:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752690AbZK1Roh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 12:44:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:34456 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbZK1Rog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 12:44:36 -0500
Date: Sat, 28 Nov 2009 09:45:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Breuer <mbreuer@majjas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Problem? intel_iommu=off; perf top shows acpi_os_read_port as
 extremely busy
Message-ID: <20091128094530.0ede7b1a@infradead.org>
In-Reply-To: <20091128071808.GA32183@elte.hu>
References: <4B106CC0.4050406@majjas.com>
	<20091128071808.GA32183@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Nov 2009 08:18:08 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Michael Breuer <mbreuer@majjas.com> wrote:
> 
> > Having given up for now on VT-D, I rebooted 2.6.38 rc8 with 
> > intel_iommu=off. Whilst my myriad of broken bios issues cleared, I
> > now see in perf top acpi_os_read_port as continually the busiest
> > function. With intel_iommu enabled, _spin_lock was always on top,
> > and nothing else was notable.
> > 
> > This seems odd to me, perhaps this will make sense to someone else.
> > 
> > FWIW, I'm running on an Asus p6t deluxe v2; ht enabled; no errors
> > or oddities in dmesg or /var/log/messages.
> 
> Could you post the perf top output please?
> 
> Also, could you also post the output of:
> 
> 	perf stat -a --repeat 10 sleep 1
> 
> this will show us how idle the system is. (My guess is that your
> system is idle and perf top shows acpi_os_read_port because the
> system goes to idle via ACPI methods and PIO is slow. In that case
> all is nominal and your system is fine. But it's hard to tell without
> more details.)
> 

yeah the os_read_port is part of the idle loop, so if your system is
idle it'll show up big.... not much we can optimize there though...
