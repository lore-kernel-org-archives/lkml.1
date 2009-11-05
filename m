Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbZKEEqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbZKEEqO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 23:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbZKEEqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 23:46:13 -0500
Received: from sh.osrg.net ([192.16.179.4]:50048 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716AbZKEEqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 23:46:12 -0500
Date: Thu, 5 Nov 2009 13:44:45 +0900
To: mingo@elte.hu
Cc: tj@kernel.org, joerg.roedel@amd.com, jbarnes@virtuousgeek.org,
       dwmw2@infradead.org, fujita.tomonori@lab.ntt.co.jp, x86@kernel.org,
       tglx@linutronix.de, hpa@zytor.com, athena@fftw.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix iommu=nodac parameter handling
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20091104122827.GB11968@elte.hu>
References: <4AE5B52A.4050408@kernel.org>
	<20091104122827.GB11968@elte.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20091105134306W.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 05 Nov 2009 13:44:48 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 13:28:27 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > nodac should forbid dac instead of enabling it.  Fix it.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Matteo Frigo <athena@fftw.org>
> > Cc: stable@kernel.org
> > ---
> > This was posted several months ago in a two patch series.  The second
> > one was rejected by Alan and with that the first one got lost too
> > although it's an apparent bug fix.  Matteo hit this bug recently and
> > reminded me about this patch.  So, regenerated and reposting.
> > 
> > Thanks.
> > 
> >  arch/x86/kernel/pci-dma.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index d20009b..8cf3996 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> > @@ -216,7 +216,7 @@ static __init int iommu_setup(char *p)
> >  		if (!strncmp(p, "allowdac", 8))
> >  			forbid_dac = 0;
> >  		if (!strncmp(p, "nodac", 5))
> > -			forbid_dac = -1;
> > +			forbid_dac = 1;
> >  		if (!strncmp(p, "usedac", 6)) {
> >  			forbid_dac = -1;
> >  			return 1;
> 
> (Cc:-ed more interested parties.)

Looks fine to me.
