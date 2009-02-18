Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZBRPva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZBRPva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 10:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751720AbZBRPvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 10:51:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:56445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZBRPvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:51:20 -0500
Date: Wed, 18 Feb 2009 16:51:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perfcounters: allow sysadmin to restrict non-root
	counting of kernel events
Message-ID: <20090218155111.GB23989@elte.hu>
References: <18843.57965.710475.395466@cargo.ozlabs.ibm.com> <1234958840.4637.61.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234958840.4637.61.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-02-18 at 21:26 +1100, Paul Mackerras wrote:
> > Impact: security feature
> > 
> > This allows the sysadmin to prevent non-root users from counting
> > hardware events that occur in kernel or hypervisor mode via a sysfs file:
> > 
> > 	/sys/devices/system/cpu/perf_counters/restrict_kernel_events
> > 
> > This defaults to off (0), allowing users to count kernel and hypervisor
> > events, but if the sysadmin writes 1 to that file, any new counters
> > created by non-root users will automatically be set to ignore kernel
> > and hypervisor events.
> > 
> > This could be useful if there is a concern that allowing non-root users
> > to count kernel or hypervisor events might leak sensitive information.
> 
> I would expect it the other way around, don't allow users 
> access to kernel/hv events unless explicitly granted.

i think it's useful to make userspace developers aware of the 
kernel overhead they are causing - while still allowing policy 
settings to override that default.

Maybe the name of the control should be switched around, to 
allow_kernel_events? [with the same functional end result though 
- i.e. default-enabled]

	Ingo
