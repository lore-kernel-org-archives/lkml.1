Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab0CDIxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:53:13 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:55646
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754347Ab0CDIxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:53:12 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lzz1202hzzz32i2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYR20A-01-3OO-02
X-M-MSG: 
Date: Thu, 4 Mar 2010 09:52:56 +0100
From: Robert Richter <robert.richter@amd.com>
To: eranian@google.com
CC: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com, davem@davemloft.net
Subject: Re: [PATCH] perf_events: add sampling period randomization support
 (v2)
Message-ID: <20100304085256.GN13205@erda.amd.com>
References: <1267575705-10054-1-git-send-email-eranian@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1267575705-10054-1-git-send-email-eranian@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 04 Mar 2010 08:52:56.0818 (UTC) FILETIME=[15B5B520:01CABB78]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.03.10 16:21:45, eranian@google.com wrote:
> This patch adds support for randomizing the sampling period.  Randomization
> is very useful to mitigate the bias that exists with sampling. The random
> number generator does not need to be sophisticated. This patch uses the
> builtin random32() generator.
> 
> Randomization is activated by setting perf_event_attr.random_period_width
> to a non-zero value. It represents the width of the mask to apply to the
> random value, i.e, maximum range of variation. The random value is applied
> AROUND the period, i.e., period may be longer or shorter with a maximum
> variation of half the bit width. Thus, on average the sampling period remains
> equal to the initial period passed in perf_event_attr.sample_period.
> 
> Note that randomization is not available when a target interrupt rate
> (freq) is enabled.
> 
> The last used period can be collected using the PERF_SAMPLE_PERIOD flag
> in sample_type.
> 
> Randomization is implemented in generic code thus it applies to all
> PMU models and software events.
> 
> 	Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> --
>  include/linux/perf_event.h |    3 +++
>  kernel/perf_event.c        |   44 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 47 insertions(+)

Reviewed-by: Robert Richter <robert.richter@amd.com>

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

