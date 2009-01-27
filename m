Return-Path: <linux-kernel-owner+w=401wt.eu-S1755454AbZA0P3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454AbZA0P3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 10:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZA0P26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 10:28:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41397 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751461AbZA0P25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 10:28:57 -0500
Date: Tue, 27 Jan 2009 16:28:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090127152830.GA22373@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200901261711.43943.rusty@rustcorp.com.au> <20090125230130.bcdab2e5.akpm@linux-foundation.org> <200901271735.12034.rusty@rustcorp.com.au> <20090126232519.44f2943c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126232519.44f2943c.akpm@linux-foundation.org>
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

> > But it's a general comment about fixing a general issue.  The 
> > currently known case is not directly relevent; that it can happen and 
> > it's restricting the use of this otherwise-general API is.
> 
> I think we should switch acpi-cpufreq to smp_call_function(), revert 
> this stuff and ban the calling of work_on_cpu() under locks.

I agree that do_drv_read()/write() should be converted to 
smp_function_call() (what it does is atomic: msr or PIO cycles).

Then work_on_cpu() can be removed for good, to not lure people into using 
it. You seem to agree that work_on_cpu() is unfixable so it's far better 
to offer nothing than to offer such a deceivingly named but fundamentally 
limited facility.

	Ingo
