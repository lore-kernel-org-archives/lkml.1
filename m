Return-Path: <linux-kernel-owner+w=401wt.eu-S1752120AbYACNHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbYACNHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:07:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbYACNGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:06:31 -0500
Received: from ns1.suse.de ([195.135.220.2]:56750 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbYACNG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:06:28 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [5/20] x86: Introduce nsec_barrier()
Date: Thu, 3 Jan 2008 13:55:44 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
References: <20080103149.088038000@suse.de> <20080103005000.65D0C14D40@wotan.suse.de> <20080103104754.GD29194@elte.hu>
In-Reply-To: <20080103104754.GD29194@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801031355.44694.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008 11:47:54 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > nsec_barrier() is a new barrier primitive that stops RDTSC speculation 
> > to avoid races with timer interrupts on other CPUs.
> > 
> > Add it to all architectures. Except for x86 it is a nop right now. I 
> > only tested x86, but it's a very simple change.
> > 
> > On x86 it expands either to LFENCE (for Intel CPUs) or MFENCE (for AMD 
> > CPUs) which stops RDTSC on all currently known microarchitectures that 
> > implement SSE. On CPUs without SSE there is generally no RDTSC 
> > speculation.
> 
> i've picked up your rdtsc patches into x86.git but have simplified it: 
> there's no nsec_barrier() anymore - rdtsc() is always synchronous. 
> MFENCE/LFENCE is fast enough. Open-coding such barriers almost always 
> leads to needless trouble. Please check the next x86.git tree.

That's most likely wrong unless you added two barriers -- the barriers
are strictly need to be before and after RDTSC.

I still think having the open barrier is the better approach here.

It's also useful for performance measurements because it allows
a cheap way to measure a specific region with RDTSC

-Andi
