Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067Ab0A2Wzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab0A2Wzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:55:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783Ab0A2Wzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:55:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47774 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab0A2Wzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:55:40 -0500
Message-ID: <4B636646.50605@zytor.com>
Date: Fri, 29 Jan 2010 14:50:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       eranian@google.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] bitops: Provide compile time HWEIGHT{8,16,32,64}
References: <20100122155535.797688466@chello.nl>	 <tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>	 <20100129020128.716af8fb.akpm@linux-foundation.org> <1264763023.4283.2213.camel@laptop>
In-Reply-To: <1264763023.4283.2213.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2010 03:03 AM, Peter Zijlstra wrote:
> 
> *sigh* and here I though it being placed right next to hweight_long()
> which uses the arch hweightN() would be clue enough.
> 
> If people are so clueless, who says they'll read a comment.. but sure I
> guess I can add one.
> 

I would personally say that the Right Way[TM] to do this is to call
these __constant_hweightX() -- so the name reflects the function -- and
then have

#define hweight(x) (__builtin_constant_p(x) ? __constant_hweight(x) :
__arch_hweight(x))

[example does not reflect actual naming]

	-hpa
