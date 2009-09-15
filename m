Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbZIOPCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbZIOPCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbZIOPCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:02:08 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:46689
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754551AbZIOPCH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:02:07 -0400
X-SpamScore: 5
X-BigFish: VPS5(zz1432R98dN873fizz1202hzz3198u327alz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KQ0PMX-03-NOE-01
Date: Tue, 15 Sep 2009 16:59:23 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86 <x86@kernel.org>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree build failure] Re: [GIT PULL] AMD64 EDAC updates,
 p1
Message-ID: <20090915145923.GC3824@aftab>
References: <20090914171905.GD13615@aftab>
 <20090915110940.GA8134@elte.hu>
 <20090915163837.35701344@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20090915163837.35701344@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Sep 2009 14:59:23.0898 (UTC) FILETIME=[1CCE5DA0:01CA3615]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 04:38:37PM +0200, Jean Delvare wrote:
> On Tue, 15 Sep 2009 13:09:40 +0200, Ingo Molnar wrote:
> > -tip testing found this build failure with the attached config:
> > 
> > drivers/edac/edac_mce_amd.c: In function ‘decode_mce’:
> > drivers/edac/edac_mce_amd.c:408: error: ‘per_cpu__cpu_llc_id’ undeclared (first use in this function)
> > drivers/edac/edac_mce_amd.c:408: error: (Each undeclared identifier is reported only once
> > drivers/edac/edac_mce_amd.c:408: error: for each function it appears in.)
> > 
> > I did the patchlet below but this needs a cleaner fix eventually. A 
> > proper node abstraction needs to be factored out and provided as a 
> > facility regardless of config settings.
> > 
> > 	Ingo
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> >  drivers/edac/edac_mce_amd.c |    5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > Index: linux2/drivers/edac/edac_mce_amd.c
> > ===================================================================
> > --- linux2.orig/drivers/edac/edac_mce_amd.c
> > +++ linux2/drivers/edac/edac_mce_amd.c
> > @@ -405,8 +405,11 @@ void decode_mce(struct mce *m)
> >  		regs.nbsh  = (u32)(m->status >> 32);
> >  		regs.nbeal = (u32) m->addr;
> >  		regs.nbeah = (u32)(m->addr >> 32);
> > +#ifdef CONFIG_X86_HT
> >  		node       = per_cpu(cpu_llc_id, m->extcpu);
> > -
> > +#else
> > +		node	   = 0;
> > +#endif
> >  		amd_decode_nb_mce(node, &regs, 1);
> >  		break;
> >  
> 
> FWIW, this patch doesn't fix the problem for me. Amerigo Wang's does:
> http://lkml.org/lkml/2009/9/15/64

We'll have an even better fix soon:
http://marc.info/?l=linux-kernel&m=125302459621925

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

