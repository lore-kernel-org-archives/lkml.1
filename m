Return-Path: <linux-kernel-owner+w=401wt.eu-S1753942AbYHWQJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942AbYHWQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 12:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbYHWQJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 12:09:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40779 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbYHWQJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 12:09:20 -0400
Date: Sat, 23 Aug 2008 18:08:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pawel MOLL <pawel.moll@st.com>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] genirq: irq_chip->startup() usage in setup_irq and
	set_irq_chained handler
Message-ID: <20080823160859.GE27974@elte.hu>
References: <1219313656.31630.89.camel@bri1004.bri.st.com> <1219416584.31630.639.camel@bri1004.bri.st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219416584.31630.639.camel@bri1004.bri.st.com>
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


* Pawel MOLL <pawel.moll@st.com> wrote:

> Hi, Ingo,
> 
> Apparently I have swapped To: and Cc: field in the original mail,
> apologies.
> 
> > This patch clarifies a usage of irq_chip->startup() callback:
> > 
> > 1. The "if (startup) startup(); else enabled();" code in setup_irq()
> >    is unnecessary, as startup() falls back to enabled() via
> >    default callbacks, set by irq_chip_set_defaults().
> > 
> > 2. When using set_irq_chained_handler() the startup() was never called,
> >    which is not good at all... Fixed. And again - when startup() is not
> >    defined the call will fall back to enable() than to unmask() via
> >    default callbacks.
> 
> Any comment on the patch?

looks good to me at first glance - but i Cc:-ed Thomas and Ben, maybe 
they have further comments.

	Ingo
