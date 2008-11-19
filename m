Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbYKSTtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbYKSTtr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 14:49:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbYKSTtj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 14:49:39 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59426 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbYKSTti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 14:49:38 -0500
X-IronPort-AV: E=McAfee;i="5100,188,5439"; a="13279976"
Message-ID: <49246DD0.3010509@qualcomm.com>
Date: Wed, 19 Nov 2008 11:49:36 -0800
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Gregory Haskins <ghaskins@novell.com>
CC: Dimitri Sivanich <sivanich@sgi.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com>
In-Reply-To: <4910634C.1020207@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gregory Haskins wrote:
> If you tried creating different cpusets and it still had them all end up
> in the def_root_domain, something is very broken indeed.  I will take a
> look.

I beleive that's the intended behaviour. We always put cpus that are not
balanced into null sched domains. This was done since day one (ie when
cpuisol= option was introduced) and cpusets just followed the same convention.

I think the idea is that we want to make balancer a noop on those processors.
We could change cpusets code to create a root sched domain for each cpu I
guess. But can we maybe scale cpupri some other way ?

Max
