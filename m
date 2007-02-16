Return-Path: <linux-kernel-owner+w=401wt.eu-S932266AbXBPMoI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbXBPMoI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 07:44:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXBPMoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 07:44:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49508 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbXBPMoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 07:44:07 -0500
Date: Fri, 16 Feb 2007 13:41:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] killing the NR_IRQS arrays.
Message-ID: <20070216124117.GB4218@elte.hu>
References: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ire2e20p.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.8
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.8 required=5.9 tests=ALL_TRUSTED,BAYES_50 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric W. Biederman <ebiederm@xmission.com> wrote:

> So I propose we remove all assumptions from the code that we actually 
> have an array of irqs.  That will allow for irq_desc to be dynamically 
> allocated instead of statically allocated saving memory and reducing 
> kernel complexity.

hm. I'd suggest to do this without changing request_irq() - and then we 
could avoid the 'massive, every driver affected' change, right?

i.e. because we'll (have to) have an nr_to_desc() and desc_to_nr() 
mapping facility anyway, lets just not change the driver APIs massively. 
There dont seem to be that many drivers that assume that irq_desc[] is 
an array - are there?

otherwise, in terms of the irqchips infrastructure and the API between 
genirq and the irqchip arch-level drivers, this change makes quite a bit 
of sense i think.

or am i missing something fundamental?

	Ingo
