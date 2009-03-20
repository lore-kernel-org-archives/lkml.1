Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbZCTKuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbZCTKuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbZCTKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:50:04 -0400
Received: from www.tglx.de ([62.245.132.106]:36641 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbZCTKuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:50:03 -0400
Date: Fri, 20 Mar 2009 11:49:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Michal Simek <monstr@monstr.eu>
cc: LKML <linux-kernel@vger.kernel.org>, john.williams@petalogix.com,
       John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 08/57] microblaze_v7: Interrupt handling, timer support,
 selfmod code
In-Reply-To: <49C371F5.5010100@monstr.eu>
Message-ID: <alpine.LFD.2.00.0903201142300.29264@localhost.localdomain>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu> <0168f03c96e9479ede695a9859c8a0691baa8ef3.1237407249.git.monstr@monstr.eu> <c1bdfabf85ce10babc3aa38d3bb7558a093bc49e.1237407249.git.monstr@monstr.eu> <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu> <5f8b2a60496983f572ef6d3b4e2f986c167a8336.1237407249.git.monstr@monstr.eu> <fbef554ff1d05fa50312d91e61a0d63d3207076c.1237407249.git.monstr@monstr.eu>
 <dad2353f129217470f0595eeed98412b4c84ed6b.1237407249.git.monstr@monstr.eu> <20fd42a1e8837c7352d35d157aa3393e88152c32.1237407249.git.monstr@monstr.eu> <alpine.LFD.2.00.0903191639530.29264@localhost.localdomain> <49C2AB09.9040300@monstr.eu>
 <alpine.LFD.2.00.0903192219500.29264@localhost.localdomain> <49C36149.9000703@monstr.eu> <alpine.LFD.2.00.0903201052340.29264@localhost.localdomain> <49C371F5.5010100@monstr.eu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Michal Simek wrote:
> Why is my .resolution: 10000000 nsecs? It seems to me weird.

Well. The resulution there is the granularity which the kernel uses to
expire application timers. Once the kernel switches to high resolution
mode it sets the granularity to 1ns.

To get high resolution mode you need two things:

1) a suitable clocksource - which needs to have the
CLOCK_SOURCE_IS_CONTINUOUS flag set

2) a clock event device which has CLOCK_EVT_FEAT_PERIODIC flag set.

3) CONFIG_HIGH_RES_TIMERS=y

Thanks,

	tglx
