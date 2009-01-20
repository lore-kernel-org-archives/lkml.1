Return-Path: <linux-kernel-owner+w=401wt.eu-S1761077AbZATSno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761077AbZATSno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 13:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZATSnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 13:43:35 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54736 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767AbZATSne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 13:43:34 -0500
Date: Tue, 20 Jan 2009 19:42:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Cc: Avi Kivity <avi@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, bugme-daemon@bugzilla.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
Message-ID: <20090120184249.GB5048@elte.hu>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera> <cX2gZ6Cy9nC.A.4dB.bJRdJB@chimera> <1232410363.4768.21.camel@kulgan.wumi.org.au> <20090120113546.GA26571@elte.hu> <1232455343.4895.4.camel@kulgan.wumi.org.au> <4975CBF8.90101@redhat.com> <1232474081.4895.76.camel@kulgan.wumi.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232474081.4895.76.camel@kulgan.wumi.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kevin Shanahan <kmshanah@ucwb.org.au> wrote:

> Running the ping test with without apache2 running in the guest:
> 
> --- hermes-old.wumi.org.au ping statistics ---
> 900 packets transmitted, 900 received, 0% packet loss, time 902740ms
> rtt min/avg/max/mdev = 0.568/3.745/272.558/16.990 ms
> 
> And with apache2 running:
> 
> --- hermes-old.wumi.org.au ping statistics ---
> 900 packets transmitted, 900 received, 0% packet loss, time 902758ms
> rtt min/avg/max/mdev = 0.625/25.634/852.739/76.586 ms
> 
> In both cases it's quite variable, but the max latency is still not as 
> bad as when running with the irq chip enabled.

So the worst-case ping latency is more than 10 times lower?

I'd say this points in the direction of some sort of KVM-internal 
wakeup/signalling latency that happens if KVM does not deschedule. For 
example it could be a bug like this: if a guest image runs at 100% CPU 
time for a long time, IRQ injections might not propagate up until the 
preemption callbacks run. (but i'm just speculating here)

	Ingo
