Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbZHYT0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbZHYT0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 15:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbZHYT0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 15:26:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56398 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbZHYT0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 15:26:52 -0400
Date: Tue, 25 Aug 2009 21:26:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ravikiran G Thirumalai <kiran@scalex86.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       shai@scalex86.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86: 2.6.31-rc7 crash due to buggy flat_phys_pkg_id
Message-ID: <20090825192624.GA12763@elte.hu>
References: <20090824182659.GA6842@localdomain> <4A932809.1000103@kernel.org> <20090825012632.GB6842@localdomain> <4A9372A1.9090905@kernel.org> <20090825171716.GC6456@localdomain> <20090825181500.GB3277@elte.hu> <20090825183130.GA5806@lenovo> <20090825192055.GD6456@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090825192055.GD6456@localdomain>
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


* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:

> On Tue, Aug 25, 2009 at 10:31:30PM +0400, Cyrill Gorcunov wrote:
> >[Ingo Molnar - Tue, Aug 25, 2009 at 08:15:00PM +0200]
> >| 
> >
> >I'm definitely not APIC expert but since I was partially involved
> >letme turn in.
> >
> >Original commit which causes problem for vSMP seems to be due
> >to cpu_has_apic bit turned off (ie due to being manually disabled
> >or acpi table broken) so further read apic id will return plain
> >zero (we're talking about 64 bits now). So frnakly I don't understand
> >what is wrong with Ravikiran's patch. In case of apic disabled
> >initial apic value will be used anyway (which is latched but
> >actually may be changed, but it's not our case).
> >
> 
> Exactly my thinking.  I hoped the patch I posted solves both cases --
> does not depend on local apic id for the "fix crash on certain UP configs"
> case in the commit here:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2759c3287de27266e06f1f4e82cbd2d65f6a044c
> 
> And fixes vsmp too.

Sidenote for .32: i am somewhat worried about the spreading of 
various cpu_has_apic checks. We should separate it out more cleanly 
and provide an apic-> callback instead and avoid this ugly flaggery.

	Ingo
