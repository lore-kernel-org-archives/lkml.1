Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464Ab0BCRLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:11:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46258 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427Ab0BCRLx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:11:53 -0500
Message-ID: <4B69ADFB.9070502@zytor.com>
Date: Wed, 03 Feb 2010 09:10:19 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/5] bitops: compile time optimization for	hweight_long(CONSTANT)
References: <20100130094515.475881280@intel.com> <20100130094957.692671259@intel.com> <20100201124825.cc024f2a.akpm@linux-foundation.org> <20100203133951.GA24357@localhost>
In-Reply-To: <20100203133951.GA24357@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2010 05:39 AM, Wu Fengguang wrote:
> 
>> (I wonder if it could have used __builtin_popcount)
>>
>> (I wonder which gcc versions support __builtin_popcount)
> 

I think 4.0 or later, but it often generates calls to libgcc, which
would mean adding libgcc functions to the kernel (which some arches
already do.)

> This is how Jamie Lokier first recommended it to me:
> 
>         Checked GCC 3.4.3 / 4.1 / 4.4: It expands as a compile-time
>         constant if the argument is a compile-time constant, so can be
>         used in BUILD_BUG_ON() and even for array sizes etc.
> 
> Is there an official lowest GCC version that Linux supports?

3.4, I believe.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

