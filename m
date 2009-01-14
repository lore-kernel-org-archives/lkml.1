Return-Path: <linux-kernel-owner+w=401wt.eu-S1760114AbZANOta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760114AbZANOta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbZANOtW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:49:22 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:61268 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZANOtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:49:22 -0500
Date: Wed, 14 Jan 2009 15:41:15 +0100
From: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ravikiran G Thirumalai <kiran@scalex86.org>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090114144115.GF10720@gambetta>
References: <20090112213539.GA10720@gambetta> <20090112223421.GA20594@localdomain> <20090112230052.GB18771@elte.hu> <1231848016.442.112.camel@twins> <20090114090811.GQ23848@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114090811.GQ23848@one.firstfloor.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:08:11AM +0100, Andi Kleen wrote:
> 
> > > It also would save some memory
> > > on most distros out there (Ubuntu x86_64 has NR_CPUS=64 by default).
> 
> As pointed out several times this claim in the changelog is incorrect.
> Please fix it.
> 
> A correct description would be:
> 
> - This patch wastes memory of one configured cache line for each CPU 
> on systems with less than 8 cores (e.g. 896 bytes on a 1 core system
> with CONFIG_GENERIC_CPU/ cache line size 128)
> It saves some memory on systems with more than 8 cores (one cache
> line size for each core above 8)
To be fair, it also depends on whenever HOTPLUG_CPU is on or not (if it
is we allocate NR_CPUS percpu sections). In that case, which is Ubuntu's
and Fedora's, we do save memory.
This would make for a fairly long changelog, how about a link to this
thread, and removing the NR_CPUS bit?

Regards,
Frederik
> 
> -Andi
> 
