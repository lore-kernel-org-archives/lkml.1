Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbYCJRY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbYCJRY6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYCJRYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:24:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbYCJRYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:24:49 -0400
Date: Mon, 10 Mar 2008 18:24:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>
Subject: Re: [patch] fix ACPI boot regression (was: Re: Linux 2.6.25-rc5)
Message-ID: <20080310172417.GA25898@elte.hu>
References: <alpine.LFD.1.00.0803092231580.5896@woody.linux-foundation.org> <20080310170434.GA22430@elte.hu> <alpine.LFD.1.00.0803101011580.5896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803101011580.5896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 10 Mar 2008, Ingo Molnar wrote:
> >
> > so zero-extending the result in the PCI-BIOS read routine fixes the 
> > regression on my laptop. ( It might fix some other long-standing 
> > issues we had with PCI-BIOS during the past decade ... ) Both 8-bit 
> > and 16-bit accesses were buggy.
> 
> Oh, wow. That must have been there forever, but very few people 
> probably ever cared.
> 
> And why is your laptop using the BIOS routines anyway? Or was that 
> just a result of your randconfig having turned off the sane config 
> access routines?

yeah, randconfig generated this:

  CONFIG_PCI=y
  CONFIG_PCI_GOBIOS=y
  # CONFIG_PCI_GOMMCONFIG is not set
  # CONFIG_PCI_GODIRECT is not set
  # CONFIG_PCI_GOANY is not set
  CONFIG_PCI_BIOS=y

which forced the PCI code into the BIOS access method on this otherwise 
modern system. I disable some of the really-known-to-be-broken .config 
options in randconfig - but i still bravely keept CONFIG_GO_PCIBIOS in 
the randomized space, which triggered this.

On another box, which has a different BIOS, this bug never happened, in 
tens of thousands of bootup tests.

	Ingo
