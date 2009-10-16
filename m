Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZJPM6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZJPM6O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 08:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759208AbZJPM6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 08:58:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:62772 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758050AbZJPM6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 08:58:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SmIE9GJeHvxWUGo40qw86SY9fabykNgRJTL5OfaeFmve9RuTjIBv5O4mSoLUbCHvGO
         xQ2JuU9Cp74bGXZoVzh3Pfg025Vk6yVwu+y0fBImRiFkqnHayS01+e/J3dmqL3keWzae
         XxRF2DyLBraCyZmuNKzvMJNopyWCnEmStaY+Y=
Date: Fri, 16 Oct 2009 14:57:00 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: x86, amd: Get multi-node CPU info from NodeId MSR instead of
 PCI config space
Message-ID: <20091016125700.GD8387@alberich.amd.com>
References: <20091016122229.GB8387@alberich.amd.com>
 <20091016123853.GA15393@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091016123853.GA15393@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 02:38:53PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <herrmann.der.user@googlemail.com> wrote:
> 
> > Use newly introduced NodeId MSR to get NodeId and number of nodes per 
> > processor.
> 
> What will happen on CPUs that dont have this MSR and got this info from 
> the PCI config space:

No PCI config space needed as all Magny-Cours CPUs should support this
when launched.

> >  static void __cpuinit amd_fixup_dcm(struct cpuinfo_x86 *c)
> >  {
> > -#ifdef CONFIG_PCI
> > -	u32 t, cpn;
> > -	u8 n, n_id;
> >  	int cpu = smp_processor_id();
> >  
> >  	/* fixup topology information only once for a core */
> >  	if (cpu_has(c, X86_FEATURE_AMD_DCM))
> >  		return;
> >  
> > -	/* check for multi-node processor on boot cpu */
> > -	t = read_pci_config(0, 24, 3, 0xe8);
> > -	if (!(t & (1 << 29)))
> >  		return;
> >  
> >  	set_cpu_cap(c, X86_FEATURE_AMD_DCM);
> 
> are there any such CPUs?

Only Magny-Cours so far.

> I.e. we want to know the effect of this patch 
> on various models of AMD CPUs - is the change really .32 safe? Does it 
> solve any problem that makes it .32 material versus being for .33?

IMHO getting rid of the PCI config space accesses as soon as possible
is a benefit, I think.


Andreas
