Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbZDBQCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbZDBQCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:02:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752784AbZDBQCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:02:34 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58826 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZDBQCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:02:32 -0400
Subject: Re: [Announce] 2.6.29-rt2
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
In-Reply-To: <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903231723090.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903252154040.3397@localhost.localdomain>
	 <alpine.LFD.2.00.0904020155320.12916@localhost.localdomain>
Content-Type: text/plain
Organization: IBM
Date: Thu, 02 Apr 2009 11:02:25 -0500
Message-Id: <1238688145.8813.16.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-02 at 02:17 +0200, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
> 
>       - fix a fork/exit bug in the signal per task cache (/me puts on
>         a huge brown paper bag - Thanks to Phillipe Reynes and Will
>         Schmidt for reporting and testing)
> 
>       - fix a group scheduling migration accounting bug (decoded with
>         and fixed by Peter Zijlstra - reported by Robin Gareus)
> 
>       - tlb gather rework by Peter Zijlstra - Thanks Peter !
> 
>       - the usual fixlets
> 
> The tlb rework might be incomplete on some of the uncountable
> incarnations of PowerPC and ARM platforms, so look out for wreckage
> and keep the usual tools (fire-extinguishers, brooms, buckets etc.)
> handy.

I can confirm that the tlb rework does appear to be missing some parts
for Power.  (Using 2.6.29-rt3 on pseries ppc64)

arch/powerpc/kernel/built-in.o:(.toc1+0x4d0): undefined reference to
`per_cpu__ppc64_tlb_batch'
<...>
mm/built-in.o:(.toc1+0xed0): more undefined references to
`per_cpu__ppc64_tlb_batch' follow

Not clear to me if this is just missing a "DEFINE_PER_CPU_LOCKED" to
replace the removed "DEFINE_PER_CPU", (similar to the prior RT patches),
or if the tlb rework is more involved.   So, I will patiently remain
tuned in.  :-)

Thanks, 
-Will


