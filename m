Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYCKTup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYCKTup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYCKTug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:50:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:46316 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYCKTuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:50:35 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5249"; a="1040562"
Message-ID: <47D6E288.4010601@qualcomm.com>
Date: Tue, 11 Mar 2008 12:50:32 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: hch@infradead.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
       linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [PATCH 1/2] cpuset: cpuset irq affinities
References: <1205215046-27085-1-git-send-email-maxk@qualcomm.com>	<1205215046-27085-2-git-send-email-maxk@qualcomm.com>	<20080311063514.GA29824@infradead.org>	<47D6BBC8.7090608@qualcomm.com> <20080311135821.99a419e2.pj@sgi.com>
In-Reply-To: <20080311135821.99a419e2.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> Max wrote:
>> Sorry I missed your comment. Actually I just looked at the archive of the
>> original thread and I do not see any comments from you. Were they maybe sent
>> in private to Peter Z ? Can you please resend them ?
> 
> I suspect Christoph is referring to a comment he made on lkml, at:
> 
>   http://lkml.org/lkml/2008/3/2/3

Got it. The comment was
> linux/irq.h must not be included in generic code, it's actually more
> and asm-generic/hw_irq.h.  Please restructure the code so that the
> cpuset code calls into an arch interface which will then be implemented
> by arch code (which in most cases will be genirq, the other can be left
> stubbed out for now)

I'm not sure I agree with that though. We need access to irq_set_affinity()
from the cpuset code. It does not seem to make sense to call some arch
specific code if that functionality is provided by the generic layer.
Also note that IRQ functionality in the cpuset is ifdefed by the
CONFIG_GENERIC_HARDIRQS, so that we guarantied to have access to the generic code.
In addition to the irq_set_affinity we need irq_iterator() which is added by
the patch. Which again is generic.

So the question is why would we want to call into an arch interface if we can
call the generic one directly ?

Max

