Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZFZSpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZFZSpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751432AbZFZSpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 14:45:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38485 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbZFZSpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 14:45:46 -0400
Date: Fri, 26 Jun 2009 20:45:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626184536.GA30885@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com> <20090626071955.GG14078@elte.hu> <20090626095119.15067a53@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626095119.15067a53@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> On Fri, 26 Jun 2009 09:19:55 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> > >  void platform_feature_init_default(int subarch_id)
> > >  {
> > > -	printk(KERN_INFO "Use default X86 platform feature set\n");
> > > +	if ((subarch_id >= 0) && (subarch_id < N_X86_SUBARCHS)) {
> > > +		if (subarch_id == X86_SUBARCH_MRST) {
> > > +			setup_mrst_default_feature();
> > > +			return;
> > > +		}
> > > +	} else {
> > > +		printk(KERN_INFO "Use default X86 platform feature
> > > set\n");
> > > +	}
> > >  }
> > 
> > Why dont we have some clean and robust PCI config space based 
> > enumeration instead of this boot ID based thing?
> 
> MRST has special PCI support that depends on having the platform 
> identified already, so if you want to use something other than a 
> flag here, maybe we could use an SFI string instead.

An SFI flag would be nicer than any PCI space method i guess - if it 
can be accessed early enough.

	Ingo
