Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0CBJNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 04:13:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:50645 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0CBJNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 04:13:36 -0500
Subject: Re: [PATCH] perf_events: add sampling period randomization support
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@google.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, paulus@samba.org,
       fweisbec@gmail.com, perfmon2-devel@lists.sf.net, robert.richter@amd.com,
       eranian@gmail.com
In-Reply-To: <1267510029-19750-1-git-send-email-eranian@google.com>
References: <1267510029-19750-1-git-send-email-eranian@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 09:21:28 +0100
Message-ID: <1267518088.25158.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 22:07 -0800, eranian@google.com wrote:
> This patch adds support for randomizing the sampling period.
> Randomization is very useful to mitigate the bias that exists
> with sampling. The random number generator does not need to
> be sophisticated. This patch uses the builtin random32()
> generator.
> 
> The user activates randomization by setting the perf_event_attr.random
> field to 1 and by passing a bitmask to control the range of variation
> above the base period. Period will vary from period to period & mask.
> Note that randomization is not available when a target interrupt rate
> (freq) is enabled.
> 
> The last used period can be collected using the PERF_SAMPLE_PERIOD flag
> in sample_type.
> 
> The patch has been tested on X86. There is also code for PowerPC but
> I could not test it.

I don't thikn we need to touch the arch code, we didn't need to for
frequency driven sampling, so I don't see a reason to do so for
randomization either.

