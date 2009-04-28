Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZD1Kdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZD1Kdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZD1KdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:33:25 -0400
Received: from mga10.intel.com ([192.55.52.92]:39062 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755053AbZD1KdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:33:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,259,1239001200"; 
   d="scan'208";a="452089525"
Message-ID: <49F6DB71.10709@linux.intel.com>
Date: Tue, 28 Apr 2009 12:33:21 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
References: <1240910841.6842.1163.camel@yhuang-dev.sh.intel.com> <1240914103.7620.110.camel@twins>
In-Reply-To: <1240914103.7620.110.camel@twins>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> We're talking about Machine Check Exceptions here, right? 

No, this is actually more about machine check events (CMCI or poll), not int #18.

> Is there a
> valid scenario where you care about performance? 

Yes corrected errors. They just get reported while the system
keep running.

In practice they can happen in bursts for a relatively short time.
Another case was dumb QA setups where people using high frequency
injection of corrected errors (that was one case the old code didn't handle
too well). Yes I would agree with you that long term high frequency is
not an interesting case still.

However there's another reason why this patchkit is very useful. The old
code didn't scale to a large number of CPUs, that is why the per CPU
buffers are needed.

> Also, it sounds like something that might fit the ftrace ringbuffer
> thingy.

We went over this before. Please read this relevant threads.

-Andi
