Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYHWWoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYHWWoP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 18:44:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753722AbYHWWoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 18:44:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:34461 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753726AbYHWWoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 18:44:04 -0400
Subject: Re: [PATCH] genirq: irq_chip->startup() usage in setup_irq and
	set_irq_chained handler
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Pawel MOLL <pawel.moll@st.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080823160859.GE27974@elte.hu>
References: <1219313656.31630.89.camel@bri1004.bri.st.com>
	 <1219416584.31630.639.camel@bri1004.bri.st.com>
	 <20080823160859.GE27974@elte.hu>
Content-Type: text/plain
Date: Sun, 24 Aug 2008 08:43:15 +1000
Message-Id: <1219531395.21386.200.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-23 at 18:08 +0200, Ingo Molnar wrote:
> > Apparently I have swapped To: and Cc: field in the original mail,
> > apologies.
> > 
> > > This patch clarifies a usage of irq_chip->startup() callback:
> > > 
> > > 1. The "if (startup) startup(); else enabled();" code in setup_irq()
> > >    is unnecessary, as startup() falls back to enabled() via
> > >    default callbacks, set by irq_chip_set_defaults().
> > > 
> > > 2. When using set_irq_chained_handler() the startup() was never called,
> > >    which is not good at all... Fixed. And again - when startup() is not
> > >    defined the call will fall back to enable() than to unmask() via
> > >    default callbacks.
> > 
> > Any comment on the patch?
> 
> looks good to me at first glance - but i Cc:-ed Thomas and Ben, maybe 
> they have further comments.

The second change is a significant semantic change. I wouldn't be
surprised if I have cases that rely (or work around) the lack of
startup() in set_irq_chained_handler(). I'll have to dbl check things
next week. Can you send me a copy of those patches ?

Cheers,
Ben.


