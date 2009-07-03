Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbZGCSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbZGCSta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756192AbZGCStW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 14:49:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36454 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947AbZGCStU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 14:49:20 -0400
Date: Fri, 3 Jul 2009 20:48:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
Message-ID: <20090703184855.GA6931@elte.hu>
References: <20090703000829.735976000@intel.com> <20090703065427.GA32687@elte.hu> <7E82351C108FA840AB1866AC776AEC4669BFF052@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7E82351C108FA840AB1866AC776AEC4669BFF052@orsmsx505.amr.corp.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

>  
> 
> >-----Original Message-----
> >From: Ingo Molnar [mailto:mingo@elte.hu] 
> >Sent: Thursday, July 02, 2009 11:54 PM
> >To: Pallipadi, Venkatesh
> >Cc: Dave Jones; linux-kernel@vger.kernel.org; 
> >cpufreq@vger.kernel.org; kernel-testers@vger.kernel.org; 
> >Rafael J. Wysocki; Dave Young; Pekka Enberg; Mathieu 
> >Desnoyers; Thomas Renninger
> >Subject: Re: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
> >
> >
> >* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:
> >
> >> Since recent chanegs to ondemand and conservative governor, there 
> >> have been multiple reports of lockdep issues in cpufreq. Patch 
> >> series takes care of these problems.
> >> 
> >> This is the next attempt following the one here, which was not a 
> >> complete fix. 
> >> http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/01073.html
> >> 
> >> I am currently running some stress tests to make sure there are no 
> >> issues with these patches. But, wanted to send them out for 
> >> review/comments/testing before I head out for the long weekend.
> >> 
> >> If this patchset seems sane, the first patch in the patchset 
> >> should also get into 30.stable.
> >
> >Btw., FYI, because my test-systems were frequently triggering those 
> >bugs, i kept testing the following series from you and Mathieu in 
> >-tip:
> >
> > ecf8b04: cpufreq: Define dbs_mutex purpose and cleanup its 
> >usage conservative gov
> > b08c597: cpufreq: Define dbs_mutex purpose and cleanup its usage
> > 0807e30: cpufreq: remove rwsem lock from CPUFREQ_GOV_STOP 
> >call (second call site)
> >
> >So that fix-series, while probably not complete (given that you sent 
> >a v2 series), worked well in practice and gets my:
> >
> > Tested-by: Ingo Molnar <mingo@elte.hu>
> >
> >Is the delta between this (tested) series and your v2 version 
> >significant? If not it might make sense to shape it as a delta patch 
> >to the v1 series, if that looks clean enough - to preserve testing 
> >results.
> >
> 
> Thanks for testing. That earlier version even though it took care 
> of lockdep complaints, did not address all the race conditions 
> properly. The delta is significant as I had to change the approach 
> compared to first patchset. So, diff will not be very clean.

Fair enough - these cases are when it makes sense to do a clean 
rebase.

	Ingo
