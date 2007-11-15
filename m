Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbXKOOSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbXKOOSG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757320AbXKOORz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:17:55 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33771 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689AbXKOORy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:17:54 -0500
Date: Thu, 15 Nov 2007 15:13:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russel <rusty@rustcorp.com.au>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Paul E McKenney <paulmck@us.ibm.com>,
       Richard Gooch <rgooch@atnf.csiro.au>,
       Tigran Aivazian <tigran@aivazian.fs.co.uk>,
       Shoahua Li <shaohua.li@linux.com>, Ralf Baechle <ralf@linux-mips.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Nathan Lynch <ntl@pobox.com>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC PATCH 0/3] Refcount Based Cpu Hotplug V3
Message-ID: <20071115141331.GA28857@elte.hu>
References: <20071115134924.GA15282@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115134924.GA15282@in.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Gautham R Shenoy <ego@in.ibm.com> wrote:

> Hi, 
> This is Try #3 for the Refcount + Waitqueue based implementation
> for cpu-hotplug locking. The earlier versions can be found at
> 
> http://lkml.org/lkml/2007/10/24/36
> and
> http://lkml.org/lkml/2007/10/16/118.
> 
> This version drops the patch 4 from the earlier series, which was 
> basically removing the CPU_DEAD and CPU_UP_CANCELLED event handling in 
> the workqueue subsystem. This was based on Oleg Nestertov's comments 
> since the problem which the patch was attempting to solve was more 
> complicated and needs to be looked into seperately.
> 
> The patch series is against v2.6.24-rc2 and has survived 
> overnight kern_bench + cpu-offline-online tests on 
> - 8 way x86, 
> - 8 way x86_64,
> - 128 way ppc64 boxes.
> 
> The patch series has gone through many iterations and looks to have 
> matured in the process.
> 
> Andrew, could you please consider it for the next -mm release if there 
> are no objections ?

really nice stuff!

Acked-by: Ingo Molnar <mingo@elte.hu>

since this is in essence a regression fix, how about a v2.6.24 merge? 
CPU online/offline never worked really reliably and it's used by 
suspend/resume as wel.

	Ingo
