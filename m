Return-Path: <linux-kernel-owner+w=401wt.eu-S1752361AbXCaISt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbXCaISt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXCaISt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:18:49 -0400
Received: from gundega.hpl.hp.com ([192.6.19.190]:56494 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbXCaISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:18:47 -0400
Date: Sat, 31 Mar 2007 00:18:32 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       Stephane Eranian <eranian@hpl.hp.com>
Subject: Re: exposing FSB clock speed in /sys
Message-ID: <20070331081832.GB17535@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070330153937.GC16059@frankl.hpl.hp.com> <p73bqiaqh32.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73bqiaqh32.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Sat, Mar 31, 2007 at 04:31:29AM +0200, Andi Kleen wrote:
> Stephane Eranian <eranian-sDzT885Ts8HQT0dZR+AlfA@public.gmane.org> writes:
> 
> > It seems that the kernel does not expose the Front-Side Bus (FSN) Clock
> > speed to user applications. 
> 
> You mean the APIC timer frequency which happens to match the FSB 
> on some CPUs? 

Well, I am talking about the bus that connects the processor socket to the
chipset on Intel machines. On Intel Core 2 Duo (aka Woodcrest), you have 
2 sockets, thus two buses connecting to the chipset which then connects
to the memory (among other things).

The Woodcrest (Intel Core PMU) is capable of measuring the number of bus
transactions to memory (look at the BUS_* events). You can count per core
or for the entire socket (both cores). In order to know if you saturate
the bus (from socket to chipset), you need to know the theoretical peak
number of transactions the bus can sustain. For that you need to bus
frequency. 

I am not interested in older processors, but I think for all recent Intel
processors, there is a fairly simple algorithm to get the frequency using
a couple of MSRs (including MSR_IA32_EBL_CR_POWERON or MSR_FSB_FREQ).

Don't we already have /sys entries that exits only for certain processors
or platforms?

I think the Opteron have HYPERTRANSPORT-related events which could be used
to obtain similar metrics.

Knowledge of bus saturation is important for multi-core programming.

>  
> > Knowledge the the FSB speed is very useful to monitoring tools. It is used
> > to compute certain bus-related metrics.
> 
> Can you describe those metrics in detail? 
> 
> -Andi

-- 

-Stephane
