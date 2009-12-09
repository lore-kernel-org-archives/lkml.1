Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210AbZLIGFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbZLIGFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:05:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbZLIGFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:05:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbZLIGFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:05:34 -0500
Date: Wed, 9 Dec 2009 07:05:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andreas Herrmann <herrmann.der.user@googlemail.com>
Subject: Re: x86: ucode-amd: Convert printk(KERN_*...) to pr_*(...)
Message-ID: <20091209060538.GD2512@elte.hu>
References: <200912082259.nB8Mx2ih008207@hera.kernel.org>
 <1260313613.27677.169.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260313613.27677.169.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joe Perches <joe@perches.com> wrote:

> On Tue, 2009-12-08 at 22:59 +0000, Linux Kernel Mailing List wrote:
> > Commit:     1a74357066369be91e6f4f431621a00b052df964
> > diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
> > index 9f13324..26e33bd 100644
> > --- a/arch/x86/kernel/microcode_amd.c
> > +++ b/arch/x86/kernel/microcode_amd.c
> []
> > @@ -113,7 +113,7 @@ static int get_matching_microcode(int cpu, void *mc, int rev)
> >  
> >  	/* ucode might be chipset specific -- currently we don't support this */
> >  	if (mc_header->nb_dev_id || mc_header->sb_dev_id) {
> > -		printk(KERN_ERR "microcode: CPU%d: loading of chipset "
> > +		pr_err(KERN_ERR "microcode: CPU%d: loading of chipset "
> >  		       "specific code not yet supported\n", cpu);
> >  		return 0;
> >  	}
> 
> Duplicates KERN_ERR

Indeed - please send a delta fix as this has been merged already.

( Andy: i suspect checkpatch could also grow a new warning perhaps, the
  '\<pr_.*(KERN_.*' pattern will i suspect pinpoint something fishy in 
  most cases. )

	Ingo
