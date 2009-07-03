Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZGCIAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZGCIAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751535AbZGCIAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:00:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41090 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZGCIAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:00:06 -0400
Date: Fri, 3 Jul 2009 09:59:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Greg KH <gregkh@suse.de>,
       x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Kurt Garloff <garloff@suse.de>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Doug Thompson <norsk5@yahoo.com>, Dave Jiang <djiang@mvista.com>
Subject: Re: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090703075924.GB13505@elte.hu>
References: <20090624213211.GA11291@kroah.com> <alpine.LFD.2.00.0906302324350.23134@eddie.linux-mips.org> <20090630223040.GA3802@suse.de> <alpine.LFD.2.00.0907010148490.23134@eddie.linux-mips.org> <20090701111003.GC15958@elte.hu> <alpine.LFD.2.00.0907011816070.18056@eddie.linux-mips.org> <20090702075305.GC19187@elte.hu> <20090702104111.GA24940@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702104111.GA24940@aftab>
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


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> On Thu, Jul 02, 2009 at 09:53:05AM +0200, Ingo Molnar wrote:
> > > That shouldn't be a problem if we were about to panic().  For a 
> > > more sophisticated attempt of recovery -- yes, that would have to 
> > > be addressed.
> > 
> > We are only panic-ing if the sysctl is set. The diagnostics 
> > would be useful anyway. The proper approach would be to defer it 
> > a bit in the non-panic case an read it out from some friendlier 
> > context - such as the EDAC core.
> 
> Quickly skimming through code shows some functionality is there: 
> drivers/edac/edac_pci{,_sysfs}.c but doesn't seem to be NMI safe. 
> CCing some more people.

the 'defer' would mean we put it into a softirq context or so and do 
it from there - not from NMI context.

But yes, if we are about to panic due to this and want to print out 
something useful, making EDAC NMI safe would be nice.

	Ingo
