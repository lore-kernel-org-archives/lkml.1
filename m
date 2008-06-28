Return-Path: <linux-kernel-owner+w=401wt.eu-S1750758AbYF1HsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750758AbYF1HsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 03:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754533AbYF1HsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 03:48:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46350 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217AbYF1HsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 03:48:10 -0400
Date: Sat, 28 Jun 2008 09:47:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix init_memory_mapping over boundary v2
Message-ID: <20080628074753.GA1856@elte.hu>
References: <200806251748.06743.yhlu.kernel@gmail.com> <200806252151.29028.yhlu.kernel@gmail.com> <200806271538.46829.yhlu.kernel@gmail.com> <200806272247.11971.yhlu.kernel@gmail.com> <20080628063500.GA15710@elte.hu> <20080628070243.GA31342@elte.hu> <86802c440806280022l76ef93c4kd18c578cdaba421a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440806280022l76ef93c4kd18c578cdaba421a@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Sat, Jun 28, 2008 at 12:02 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >>
> >> > some end boundary is only page alignment, instead of 2M alignment, so
> >> > call ker_phycial_mapping_init three times. then don't overmap above
> >> > the max_low_pfn
> >>
> >> applied to tip/x86/unify-setup, thanks Yinghai.
> >
> > -tip testing found a 32-bit spontaneous reboot during bootup, with this
> > config:
> >
> >  http://redhat.com/~mingo/misc/config-Sat_Jun_28_08_43_52_CEST_2008.bad
> >
> > no serial log produced at all.
> even with console=uart8250,io,0x03f8,115200n8 ?

correct, i use earlyprintk=serial,ttyS0,115200.

i just re-tested it - doing "git merge tip/x86/unify-setup" in the 
tip/master branch triggers the failure with that config on a wide range 
of 32-bit boxes.

	Ingo
