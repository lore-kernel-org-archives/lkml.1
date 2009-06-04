Return-Path: <linux-kernel-owner+w=401wt.eu-S1756132AbZFDF4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132AbZFDF4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZFDF4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:56:05 -0400
Received: from mga10.intel.com ([192.55.52.92]:49242 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751080AbZFDF4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:56:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,303,1241420400"; 
   d="scan'208";a="696317927"
Message-ID: <4A2761F3.2030901@linux.intel.com>
Date: Thu, 04 Jun 2009 07:56:03 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v4] x86: MCE: Re-implement MCE log ring buffer as per-CPU
 ring buffer
References: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1244085090.8361.360.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> Re-implement MCE log ring buffer as per-CPU ring buffer for better
> scalability. Basic design is as follow:

Looks good. Thanks.

Acked-by: Andi Kleen <ak@linux.intel.com>

> 
> Performance test show that the throughput of per-CPU mcelog buffer can
> reach 430k records/s compared with 5.3k records/s for original
> implementation on a 2-core 2.1GHz Core2 machine.

I should add the main reason to add the patch is less that performance
(normally there shouldn't be that many errors, so it doesn't matter too much),
but that it scales to a larger number of CPUs. The old mce log ring had a fixed
sized buffer that was hard to extend and didn't scale on larger systems,
which could cause overflows and other issues.
Also this fixes a long standing known livelock in the old code where
a very high continuous error rate could livelock the reader.

-Andi


