Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZHFQQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZHFQQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 12:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756162AbZHFQQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 12:16:27 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:57848
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756126AbZHFQQ0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 12:16:26 -0400
X-SpamScore: -17
X-BigFish: VPS-17(z34a4jz1432R98dN4015Lzz1202hzzz32i203h6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KNYQJ2-02-J4Y-02
X-M-MSG: 
Date: Thu, 6 Aug 2009 18:15:52 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Borislav Petkov <borislav.petkov@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 2/5] x86: Provide CPU topology information for
	multi-node processors
Message-ID: <20090806161552.GE7198@alberich.amd.com>
References: <20090805154402.GA6520@alberich.amd.com> <20090805154811.GC6520@alberich.amd.com> <20090806183046.8aaa7404.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090806183046.8aaa7404.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2009 16:15:52.0921 (UTC) FILETIME=[2B8DB490:01CA16B1]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 06:30:46PM +1000, Stephen Rothwell wrote:
> Hi Andrea,
> 
> On Wed, 5 Aug 2009 17:48:11 +0200 Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> >
> > @@ -1061,8 +1070,10 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
> >  	for_each_possible_cpu(i) {
> >  		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
> >  		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> > +		alloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
> >  		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
> >  		cpumask_clear(per_cpu(cpu_core_map, i));
> > +		cpumask_clear(per_cpu(cpu_node_map, i));
> 
> I noticed this in linux-next ... you can use zalloc_cpumask_var() instead
> of alloc_cpumask_var() followed by cpumask_clear().

I know, there is a collision with a patch in linux-next that replaced
alloc_cpumask_var/cpumask_clear with the zalloc version.

(a) Either that patch should be adapted to change also the new allocation.
(b) I can also change all those allocation to zalloc with my patch.

Make your choice:

[ ] (a)
[ ] (b)


Thanks,

Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


