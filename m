Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CBOSh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:18:37 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:49908 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab0CBOSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:18:36 -0500
X-SpamScore: -24
X-BigFish: VPS-24(zz1432R98dN936eM62a3Lzz1202hzzz32i2a8h6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYNRQO-02-53B-02
X-M-MSG: 
Date: Tue, 2 Mar 2010 15:18:24 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: eranian@google.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       paulus@samba.org, fweisbec@gmail.com, perfmon2-devel@lists.sf.net,
       eranian@gmail.com
Subject: Re: [PATCH] perf_events: add sampling period randomization support
Message-ID: <20100302141824.GG13205@erda.amd.com>
References: <1267510029-19750-1-git-send-email-eranian@google.com>
 <20100302105314.GF13205@erda.amd.com>
 <1267530078.25158.41.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1267530078.25158.41.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 02 Mar 2010 14:18:25.0059 (UTC) FILETIME=[389F4F30:01CABA13]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.03.10 12:41:18, Peter Zijlstra wrote:
> On Tue, 2010-03-02 at 11:53 +0100, Robert Richter wrote:
> > 
> > Only adding the random value will lead to longer sample periods on
> > average. To compensate this you could calculate something like:
> > 
> >          event->hw.sample_period = event->attr.sample_period + (new_seed & mask) - (mask >> 1);
> 
> Or cheat and do something like:
> 
>   sample_period ^= (new_seed & mask);

This wont work, it will be asymmetric, e.g. for

 (event->attr.sample_period & mask) == 0

the offset would be always positive. Only for

 (event->attr.sample_period & mask) == (mask & ~(mask >> 1))

it is correct.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

