Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbZFXPQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbZFXPQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 11:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbZFXPQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 11:16:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32838 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbZFXPQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 11:16:49 -0400
Date: Wed, 24 Jun 2009 17:16:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Gary Hade <garyhade@us.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, x86 maintainers <x86@kernel.org>,
       Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624151634.GC15037@elte.hu>
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain> <4A423686.8050905@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A423686.8050905@lwfinger.net>
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


* Larry Finger <Larry.Finger@lwfinger.net> wrote:

> Jaswinder Singh Rajput wrote:
> > On Tue, 2009-06-23 at 20:33 -0500, Larry Finger wrote:
> >> My latest pull from Linus's tree fails to boot. Bisection leads to the
> >> commit entitled "x86/ACPI: Correct maximum allowed _CRS returned
> >> resources and warn if exceeded" with hash
> >> f9cde5ffed17bf74f6bef042d99edb0622f58576. I have been unable to
> >> capture the first error message as it scrolls off the screen, but the
> >> second hits the WARN_ON at drivers/ata/ahci.c:695 in routine
> >> ahci_enable_ahci() because HOST_AHCI_EN is not set.
> >>
> > 
> > This patch fixes boot failure on my AMD 64 laptop, can you please test
> > this patch:
> > 
> > [PATCH] x86: fix _CRS resources return handling
> > 
> > We need to check for info->res_num and only handle for < PCI_BUS_NUM_RESOURCES
> > 
> > Also set info->bus->resource[info->res_num] for _CRS resources return handling
> > 
> > Fixed boot failure on some machine.
> > 
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/pci/acpi.c |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> Tested-by: Larry Finger <Larry.Finger@lwfinger.net>
> 
> Thanks for the patch. With it, my machine boots with the latest
> 2.6.30-gitX.

Please note the comments from Yinghai and Thomas. The fix does 
something weird after injecting unrelated cleanups and the changelog 
does not cover that.

	Ingo
