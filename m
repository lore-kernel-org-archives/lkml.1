Return-Path: <linux-kernel-owner+w=401wt.eu-S1759453AbYAJKDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759453AbYAJKDn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbYAJKD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:03:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39057 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759329AbYAJKD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:03:26 -0500
Date: Thu, 10 Jan 2008 11:02:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Airlie <airlied@gmail.com>
Cc: Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110100254.GA28209@elte.hu>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <21d7e9970801100144x63b02e1bga548acd3c5bed441@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21d7e9970801100144x63b02e1bga548acd3c5bed441@mail.gmail.com>
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


* Dave Airlie <airlied@gmail.com> wrote:

> > - firstly, there's no rationale given. So we'll change ioremap()/etc.
> >   from doing a cflush-range instruction instead of a WBINVD. But why?
> >   WBINVD isnt particular fast (takes a few msecs), but why is that a
> >   problem? Drivers dont do high-frequency ioremap-ing. It's typically
> >   only done at driver/device startup and that's it. Whether module load
> >   time takes 1254 msecs instead of 1250 msecs is no big deal.
> 
> read graphics drivers, even though I think we may avoid the whole path 
> if we can and end up doing some of this in the drivers when they know 
> more about the situation so can avoid safeties..

by 'read graphics drivers' do you mean direct framebuffer access? In any 
case, a driver (or even userspace) can use cflush just fine, it's an 
unprivileged instruction. But this is about the ioremap() implementation 
using cflush instead of WBINVD, and that is a slowpath and is up to the 
kernel anyway - i'm not aware of many high-frequency ioremap() users, so 
robustness concerns control the policy here. So could you please explain 
your point in more detail?

	Ingo
