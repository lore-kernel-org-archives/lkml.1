Return-Path: <linux-kernel-owner+w=401wt.eu-S1762776AbYCZRWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762776AbYCZRWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761986AbYCZRK4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:10:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39979 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760235AbYCZRKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:10:54 -0400
Date: Wed, 26 Mar 2008 18:09:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 02/10] init: move setup of nr_cpu_ids to as early as
	possible v2
Message-ID: <20080326170950.GB20016@elte.hu>
References: <20080325220650.835342000@polaris-admin.engr.sgi.com> <20080325220651.146336000@polaris-admin.engr.sgi.com> <20080326062725.GD18301@elte.hu> <47EA6F39.6020909@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47EA6F39.6020909@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Move the setting of nr_cpu_ids from sched_init() to 
> >> setup_per_cpu_areas(), so that it's available as early as possible.
> > 
> > hm, why not a separate call before setup_per_cpu_areas(), so that we can 
> > avoid spreading this from generic kernel into a bunch of architectures 
> > that happen to have their own version of setup_per_cpu_areas():
> > 
> >>  7 files changed, 43 insertions(+), 15 deletions(-)
> > 
> > 	Ingo
> 
> I had this before but I then discovered that an arch would increase 
> (and possible decrease) it's number of possible cpus in 
> setup_per_cpu_areas(). So I figured that setting nr_cpu_ids (and the 
> cpumask_of_cpu map) should be a side effect of setup_per_cpu_areas().

well, then why not do it shortly after setup_per_cpu_areas()? That still 
moves it earlier than sched_init() but doesnt export all this code and 
complexity toevery setup_per_cpu_areas() implementation. (which clearly 
didnt need this complexity before)

	Ingo
