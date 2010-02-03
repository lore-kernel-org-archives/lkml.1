Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757726Ab0BCTz7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 14:55:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48732 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0BCTzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 14:55:55 -0500
Message-ID: <4B69D362.10608@zytor.com>
Date: Wed, 03 Feb 2010 11:49:54 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@amd64.org>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for hweight_long(CONSTANT)
References: <20100130094515.475881280@intel.com>	 <20100130094957.692671259@intel.com>	 <20100201124825.cc024f2a.akpm@linux-foundation.org>	 <20100203133951.GA24357@localhost>	 <20100203070825.e36b3932.akpm@linux-foundation.org>	 <1265210157.24455.646.camel@laptop>	 <20100203074251.e2caa3f3.akpm@linux-foundation.org>	 <20100203181425.GB1367@aftab> <1265222875.24455.1020.camel@laptop>
In-Reply-To: <1265222875.24455.1020.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 10:47 AM, Peter Zijlstra wrote:
> On Wed, 2010-02-03 at 19:14 +0100, Borislav Petkov wrote:
> 
>> alternative("call hweightXX", "popcnt", X86_FEATURE_POPCNT)
> 
> Make sure to apply a 0xff bitmask to the popcnt r16 call for hweight8(),
> and hweight64() needs a bit of magic for 32bit, but yes, something like
> that ought to work nicely.
> 

Arguably the "best" option is to have the alternative being a jump to an
out-of-line stub which does the necessary parameter marshalling before
calling a stub.  This technique is already used in a few other places.

	-hpa
