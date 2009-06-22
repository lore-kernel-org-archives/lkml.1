Return-Path: <linux-kernel-owner+w=401wt.eu-S1751976AbZFVLty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbZFVLty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZFVLtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:49:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45474 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbZFVLtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:49:46 -0400
Date: Mon, 22 Jun 2009 13:49:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.1 - System calls - ioctl
Message-ID: <20090622114931.GB24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
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


> I/ General API comments
>
> 1/ System calls
>
>   * ioctl()
>
>    You have defined 5 ioctls() so far to operate on an existing
>    event. I was under the impression that ioctl() should not be
>    used except for drivers.
>
> How do you justify your usage of ioctl() in this context?

We can certainly do a separate sys_perf_counter_ctrl() syscall - and
we will do that if people think the extra syscall slot is worth it
in this case.

The (mild) counter-argument so far was that the current ioctls are
very simple over "IO" attributes of counters:

 - enable
 - disable
 - reset
 - refresh
 - set-period

So they could be considered 'IO controls' in the classic sense and
act as a (mild) exception to the 'dont use ioctls' rule.

They are not some weird tacked-on syscall functionality - they
modify the IO properties of counters: on/off, value and rate. If
they go beyond that we'll put it all into a separate syscall and
deprecate the ioctl (which will have a relatively short half-time
due to the tools being hosted in the kernel repo).

This could happen right now in fact, if people think it's worth it.
