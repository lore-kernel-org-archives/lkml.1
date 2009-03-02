Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZCBWME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZCBWME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZCBWLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 17:11:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37433 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658AbZCBWLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 17:11:53 -0500
Date: Mon, 2 Mar 2009 23:11:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>,
       "dri-devel@lists.sourceforge.net" <dri-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [TIP,regression,i915] /dev/dri/card0 is no longer present
Message-ID: <20090302221143.GA31162@elte.hu>
References: <20090301110455.GA18547@silver.sucs.org> <20090301113948.GA3602@elte.hu> <20090301134809.GA4753@silver.sucs.org> <1236020758.4586.76.camel@localhost.localdomain> <20090302213412.GB25076@elte.hu> <1236030235.4586.79.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236030235.4586.79.camel@localhost.localdomain>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> On Mon, 2009-03-02 at 13:34 -0800, Ingo Molnar wrote:
> > * Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
> > 
> > > On Sun, 2009-03-01 at 05:48 -0800, Sitsofe Wheeler wrote:
> > > > On Sun, Mar 01, 2009 at 12:39:48PM +0100, Ingo Molnar wrote:
> > > > >
> > > > > Thanks, i've reverted the commit for now. Could you please send
> > > > > a 'dmesg' from the bootup with the failed driver? By all
> > > > > likelyhood an ioremap failure causes a driver failure.
> > > > >
> > > > 
> > > > See below (drm says it initalized though...):
> > > > 
> > > > [    0.000000] Linux version 2.6.29-rc6-00006-g17581ad (@verona) (gcc version 4.2.4) #87 Sun Mar 1 13:42:28 GMT 2009
> > > > [    0.000000] KERNEL supported cpus:
> > > > [    0.000000]   Intel GenuineIntel
> > > > [    0.000000] PAT WC disabled due to known CPU erratum.
> > > 
> > > Looks like PAT is getting disabled on this platform. Can you 
> > > send the output of /proc/cpuinfo please.
> > 
> > Does this mean we failed an ioremap()? We still should not fail 
> > a device ioremap _ever_. We should just fall back to UC and be 
> > done with it. We may emit a warning if we consider it 
> > troublesome, but we should never ever break working drivers 
> > really.
> > 
> 
> No. We don't break ioremap. We try to fallback on UC_MINUS 
> here. But, there is something wrong happening in that path, 
> that is resulting in this issue. I am looking at that right 
> now.

ah, ok.

> I have found another problem with this particular patch, on 
> one of test systems. So, let us keep the revert until I fix 
> what looks like two different problems here.

ok.

	Ingo
