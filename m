Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbZEFQP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbZEFQP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 12:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756696AbZEFQPU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 12:15:20 -0400
Received: from wa4ehsobe003.messaging.microsoft.com ([216.32.181.13]:43615
	"EHLO WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754390AbZEFQPS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 12:15:18 -0400
X-BigFish: VPS-16(z34a4jz1432R98dR1805M936fJzz1202hzzz32i6bh15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ8D52-02-3QR-01
Date: Wed, 6 May 2009 18:14:40 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: introduce cpuinfo->cpu_node_id to reflect
	topology of multi-node CPU
Message-ID: <20090506161440.GB2868@alberich.amd.com>
References: <20090504173330.GF28728@alberich.amd.com> <20090504173450.GG28728@alberich.amd.com> <20090506114423.GM25203@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090506114423.GM25203@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 May 2009 16:15:03.0665 (UTC) FILETIME=[D030D610:01C9CE65]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 01:44:23PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> > ---
> >  arch/x86/include/asm/processor.h |    2 ++
> >  arch/x86/kernel/cpu/common.c     |    2 ++
> >  arch/x86/kernel/cpu/proc.c       |    1 +
> >  arch/x86/kernel/smpboot.c        |    5 ++++-
> >  4 files changed, 9 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> > index 0b2fab0..b49d72b 100644
> > --- a/arch/x86/include/asm/processor.h
> > +++ b/arch/x86/include/asm/processor.h
> > @@ -106,6 +106,8 @@ struct cpuinfo_x86 {
> >  	u16			booted_cores;
> >  	/* Physical processor id: */
> >  	u16			phys_proc_id;
> > +	/* Node id in case of multi-node processor: */
> > +	u16			cpu_node_id;
> 
> btw., do you have any plans to propagate this information into the 
> scheduler domains tree?

No plans yet -- as I don't know much about the scheduler code so far.
But it's worth it and I'll do it.

> Another level of domains, to cover the two internal nodes, would do 
> the trick nicely and automatically. This would work even if the BIOS 
> does not provide information and we have to go to lowlevel registers 
> or CPUID to recover it.

Yes.

(And maybe for powersaving reasons it might be worth to use nodes on
same socket instead of nodes on different sockets. But I have to check
that in-depth first.)

> This can be done even if there's no SRAT. (there's no SRAT because 
> say due to interleaving there's no real NUMA structure of memory. 
> But there's still CPU scheduling differences worth expressing.)

Seconded.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


