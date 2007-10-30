Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXJ3HUC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXJ3HUC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 03:20:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXJ3HTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 03:19:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47052 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734AbXJ3HTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 03:19:53 -0400
Date: Tue, 30 Oct 2007 08:19:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ian Pratt <Ian.Pratt@cl.cam.ac.uk>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, rusty@rustcorp.com.au,
       Avi Kivity <avi@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Glauber de Oliveira Costa <glauber@t60.localdomain>,
       Dan Hecht <dhecht@vmware.com>, Garrett Smith <garrett@vmware.com>
Subject: Re: [PATCH] raise tsc clocksource rating
Message-ID: <20071030071919.GB17074@elte.hu>
References: <11936994092607-git-send-email-gcosta@redhat.com> <1193697734.9793.86.camel@bodhitayantram.eng.vmware.com> <20071029224852.GA27547@elte.hu> <47266431.1010500@goop.org> <20071029225528.GA31293@elte.hu> <47266A00.4040408@goop.org> <20071029232140.GA10518@elte.hu> <8A87A9A84C201449A0C56B728ACF491E34C5F5@liverpoolst.ad.cl.cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A87A9A84C201449A0C56B728ACF491E34C5F5@liverpoolst.ad.cl.cam.ac.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ian Pratt <Ian.Pratt@cl.cam.ac.uk> wrote:

> > > Sigh, I don't really want to have this fight again.
> > 
> > i dont remember us having discussed this before, ever. If there's any
> > "fight" about monotonicity and SMP then it would be a pretty onesided
> > affair, with you being beaten up seriously ;-)
> 
> Actually, it is possible, even for NUMA systems with CPUs running off 
> completely different oscillators, and in the presence of CPU frequency 
> changes, power management, and even in the presence of thermal 
> throttling (though the latter introduces temporary inaccuracies it 
> doesn't affect monotonicity or rate).
> 
> Take a look at the Xen code to see how each physical CPU is 
> independently calibrated on an ongoing basis, how movement of VCPUs 
> between physical CPUs is tracked, and how shared variables are used to 
> ensure montonicity if a guest requires it.

I think that's wishful thinking. Check out:

    http://people.redhat.com/mingo/time-warp-test/time-warp-test.c

change TEST_TSC to 0, run it on an SMP guest (on a reasonably fast 
machine) and let me know whether you can make SMP guests not come up 
with monotonicity violations in the CLOCK tests.

	Ingo
