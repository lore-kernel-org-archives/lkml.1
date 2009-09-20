Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZITSaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZITSaQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755451AbZITSaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:30:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:43391 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbZITSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SgoiOV5jyEThfvTi3KjHd2W0xK2k+jAMHl/HS30X5MzRfy3KVGo89C7V88PGjgAonP
         4/y7e9uOKex5dWObI6APWcvoso8VpUtC9MuLfii+aiMbLfY+bpJh6Kux8Ef13ONZIAx6
         BFTx1gyPeNW/OMZsvAhcn+tnPqc9uBdZG32Gw=
Date: Sun, 20 Sep 2009 22:30:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sheng Yang <sheng@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org,
       Dimitri Sivanich <sivanich@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: Don't ack_APIC_irq() if lapic is disabled in
	GENERIC_INTERRUPT_VECTOR handler
Message-ID: <20090920183011.GC32176@lenovo>
References: <1252403546-12544-1-git-send-email-sheng@linux.intel.com> <20090920180632.GB8498@elte.hu> <20090920181326.GB32176@lenovo> <20090920182124.GD8498@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090920182124.GD8498@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Sun, Sep 20, 2009 at 08:21:24PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Ingo Molnar - Sun, Sep 20, 2009 at 08:06:32PM +0200]
| > | 
| > | * Sheng Yang <sheng@linux.intel.com> wrote:
| > | 
| > | > Otherwise would cause trouble...
| > | > 
| > | > Cc: Dimitri Sivanich <sivanich@sgi.com>
| > | > Signed-off-by: Sheng Yang <sheng@linux.intel.com>
| > | > ---
| > | >  arch/x86/kernel/irq.c |    3 ++-
| > | >  1 files changed, 2 insertions(+), 1 deletions(-)
| > | > 
| > | > diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
| > | > index b0cdde6..78b23d0 100644
| > | > --- a/arch/x86/kernel/irq.c
| > | > +++ b/arch/x86/kernel/irq.c
| > | > @@ -257,7 +257,8 @@ void smp_generic_interrupt(struct pt_regs *regs)
| > | >  {
| > | >  	struct pt_regs *old_regs = set_irq_regs(regs);
| > | >  
| > | > -	ack_APIC_irq();
| > | > +	if (!disable_apic)
| > | > +		ack_APIC_irq();
| > | 
| > | Wont in that case the apic->ack method be a NOP?
| > | 
| > | 	Ingo
| > | 
| > 
| > iirc it was Xen related patch. So it's not that simple.
| > 
| > I've pointed out Sheng about disable_apic. I'm not Xen
| > specialist but Xen team seem to use specific apic setup
| > so our "dummy" operations are not involved (case they
| > set disable_apic=1 without "turn off" apic ops in real).
| > Something like that.
| 
| They should then set a NOP function in that case. We really dont want to 
| slow down hotpath functions like smp_generic_interrupt() with flaggery.
| 
| 	Ingo
| 

Well, I suppose we should wait for Sheng's comments.
I wish I would answer you but I simply don't know Xen
code :)

	-- Cyrill
