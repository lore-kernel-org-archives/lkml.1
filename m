Return-Path: <linux-kernel-owner+w=401wt.eu-S1757807AbYLLI35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbYLLI35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYLLI3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:29:49 -0500
Received: from viefep12-int.chello.at ([62.179.121.32]:40949 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753871AbYLLI3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:29:49 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] Performance Counters for Linux, v3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20081211193439.GA25986@elte.hu>
References: <20081211155230.GA4230@elte.hu>
	 <12c511ca0812111111t2992dd2cw8b4d57ac57bd0700@mail.gmail.com>
	 <20081211193439.GA25986@elte.hu>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 09:29:30 +0100
Message-Id: <1229070570.12883.14.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-11 at 20:34 +0100, Ingo Molnar wrote:

>  struct perf_counter_hw_event {
>         s64                     type;
> 
>         u64                     irq_period;
>         u32                     record_type;
> 
>         u32                     disabled     :  1, /* off by default */
>                                 nmi          :  1, /* NMI sampling   */
>                                 raw          :  1, /* raw event type */
>                                 __reserved_1 : 29;
> 
>         u64                     __reserved_2;
>  };
> 
> if the hw_event.raw bit is set to 1, then the hw_event.type is fully 
> 'raw'. The default is for raw to be 0. So negative numbers can be used 
> for sw events, positive numbers for hw events. Both can be extended 
> gradually, without arbitrarily limits introduced.

On that, I still don't think its a good idea to use bitfields in an ABI.
The C std is just not strict enough on them, and I guess that is the
reason this would be the first such usage.

