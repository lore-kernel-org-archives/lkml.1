Return-Path: <linux-kernel-owner+w=401wt.eu-S1755531AbZGALLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531AbZGALLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbZGALLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:11:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:50038 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbZGALKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:10:18 -0400
Date: Wed, 1 Jul 2009 13:10:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Greg KH <gregkh@suse.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Kurt Garloff <garloff@suse.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090701111003.GC15958@elte.hu>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org> <20090630223040.GA3802@suse.de> <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org>
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


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Tue, 30 Jun 2009, Greg KH wrote:
> 
> > >  These days an IOCK NMI typically happens in response to a PCI 
> > > SERR -- it may be useful to traverse PCI buses to find the 
> > > offender and dump this information on this occasion too.  The 
> > > south bridge may have additional status too.
> > 
> > Sure, that would be great to have.  Care to make a patch?  :)
> 
>  ENOTIME, sorry.  Next year perhaps.  Or a homework project for 
> one of the newbies. ;)

You know that this project would kill a newbie, right? :)

We have no real southbridge drivers on x86 - but we should certainly 
add some. Also, walking the PCI device tree from NMI context is 
tricky as the lists there are not NMI safe - we could crash if we 
happen to get a #IOCK while loading/unloading drivers (which is rare 
but could happen).

IMHO it's all very much desired functionality, but highly 
non-trivial.

	Ingo
