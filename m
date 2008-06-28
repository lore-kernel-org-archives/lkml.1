Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYF1HDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYF1HDQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 03:03:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYF1HDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 03:03:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59843 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752223AbYF1HC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 03:02:59 -0400
Date: Sat, 28 Jun 2008 09:02:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v2
Message-ID: <20080628070243.GA31342@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com> <200806271538.46829.yhlu.kernel@gmail.com> <200806272247.11971.yhlu.kernel@gmail.com> <20080628063500.GA15710@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080628063500.GA15710@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > some end boundary is only page alignment, instead of 2M alignment, so 
> > call ker_phycial_mapping_init three times. then don't overmap above 
> > the max_low_pfn
> 
> applied to tip/x86/unify-setup, thanks Yinghai.

-tip testing found a 32-bit spontaneous reboot during bootup, with this 
config:

  http://redhat.com/~mingo/misc/config-Sat_Jun_28_08_43_52_CEST_2008.bad

no serial log produced at all.

doing the reverts below fixes the problem.

	Ingo

commit 4ae56755fa1e1bd1500c97b5bf82d6519a261ffd
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Jun 28 08:59:44 2008 +0200

    Revert "x86: let setup_arch call init_apic_mappings for 32bit"

    This reverts commit 7fce3bb20100e5b6c42ad66c495e6348522bfd37.

commit 2703b959fc588f1b77290272f60bcf0bd8f6e557
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sat Jun 28 08:59:39 2008 +0200

    Revert "x86: fix init_memory_mapping over boundary v2"

    This reverts commit 7a41ed2c98f860da38a944d8de5b29e6ec39cf76.

