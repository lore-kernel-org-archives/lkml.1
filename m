Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbZGCOHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbZGCOHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757465AbZGCOGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:06:51 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:56837 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756407AbZGCOGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:06:49 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAL+rTUpMQWU3/2dsb2JhbACBUcxIhBIF
Date: Fri, 3 Jul 2009 10:06:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com, Dave Jones <davej@redhat.com>,
       linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       kernel-testers@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Thomas Renninger <trenn@suse.de>
Subject: Re: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
Message-ID: <20090703140637.GB10256@Krystal>
References: <20090703000829.735976000@intel.com> <20090703065427.GA32687@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090703065427.GA32687@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:04:23 up 125 days, 10:30,  3 users,  load average: 0.22, 0.14,
	0.21
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:
> 
> > Since recent chanegs to ondemand and conservative governor, there 
> > have been multiple reports of lockdep issues in cpufreq. Patch 
> > series takes care of these problems.
> > 
> > This is the next attempt following the one here, which was not a 
> > complete fix. 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/01073.html
> > 
> > I am currently running some stress tests to make sure there are no 
> > issues with these patches. But, wanted to send them out for 
> > review/comments/testing before I head out for the long weekend.
> > 
> > If this patchset seems sane, the first patch in the patchset 
> > should also get into 30.stable.
> 
> Btw., FYI, because my test-systems were frequently triggering those 
> bugs, i kept testing the following series from you and Mathieu in 
> -tip:
> 
>  ecf8b04: cpufreq: Define dbs_mutex purpose and cleanup its usage conservative gov
>  b08c597: cpufreq: Define dbs_mutex purpose and cleanup its usage
>  0807e30: cpufreq: remove rwsem lock from CPUFREQ_GOV_STOP call (second call site)
> 
> So that fix-series, while probably not complete (given that you sent 
> a v2 series), worked well in practice and gets my:
> 
>  Tested-by: Ingo Molnar <mingo@elte.hu>
> 
> Is the delta between this (tested) series and your v2 version 
> significant? If not it might make sense to shape it as a delta patch 
> to the v1 series, if that looks clean enough - to preserve testing 
> results.

The delta is very significant. The purpose of each lock changes quite a
bit. I'm preparing a patch serie that should just fix the problem
without significant locking semantic modification.

(not that I have time to do this, but I end up spending more time
looking at the proposed solutions than doing it..) ;)

Mathieu

> 
> 	Ingo
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
