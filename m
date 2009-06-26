Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbZFZJjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbZFZJjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZFZJjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:39:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52030 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbZFZJjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:39:03 -0400
Date: Fri, 26 Jun 2009 11:38:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3/9] x86/moorestown: add moorestown platform flags
Message-ID: <20090626093859.GA12571@elte.hu>
References: <43F901BD926A4E43B106BF17856F07556412B7E2@orsmsx508.amr.corp.intel.com> <20090626071955.GG14078@elte.hu> <20090626101310.4110a290@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090626101310.4110a290@lxorguk.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > Why dont we have some clean and robust PCI config space based 
> > enumeration instead of this boot ID based thing?
> 
> That strikes me as a rather dumb question given that

It's an entirely legitimate question, given that many other current 
modern subarchitectures detect themselves based on PCI config space 
early accesses or (sometimes) BIOS data structures - and that both 
of those methods are better than using boot flags.

> - Embedded x86 like devices are going to regularly occur without 
> any PCI

This proposed Intel subarchitecture comes with PCI support, 
obviously.

> - You need to know the platform in order to know how to access any
>   PCI bus that may or may not hypothetically exist.

Uhm, not really.

Have a look at arch/x86/kernel/early-quirks.c. All you generally 
need to know is a PCI ID that sits on the root bus.

Early PCI ID checks are typical and robust way to identify 'weird' 
subarchitectures. Sometimes we do it via BIOS data structures. Only 
as a last option do we want to use boot loader mechanisms - it's the 
most inflexible one really.

Furtherore, Moorestown comes with SFI and there sure can be a BIOS 
table that describes the platform properly. We can read such tables 
very early during bootup, well before platform devices are set up.

	Ingo
