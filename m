Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYEZI7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYEZI7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 04:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYEZI6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 04:58:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35039 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbYEZI6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 04:58:52 -0400
Date: Mon, 26 May 2008 10:58:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       drzeus-list@drzeus.cx
Subject: Re: [patch, -git] pcie hotplug bootup crash fix
Message-ID: <20080526085824.GA13529@elte.hu>
References: <20080524165828.GA29993@elte.hu> <20080524104024.a33116a3.akpm@linux-foundation.org> <483A7663.4000700@jp.fujitsu.com> <20080526084709.GA2182@elte.hu> <20080526015232.5faac5bb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080526015232.5faac5bb.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon, 26 May 2008 10:47:09 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> > 
> > > I updated Ingo's patch. If it's ok, I'll send it to Jess Barnes with 
> > > some other patches for the other pciehp regression problems.
> > 
> > looks good to me, thanks Kenji.
> > 
> 
> It's a bit sad to add a large workaround like this.  I'm surprised 
> that fixing it properly is considered unviable for 2.6.26.  Normally 
> these fixes are pretty simple - just request the IRQ a bit later?

hm, will that solve the problem? These irqs can be shared and there can 
be multiple of them, so making the handlers robust against 
half-constructed global state seems inevitable (the other option would 
be extra locking). But i've only looked briefly ...

	Ingo
