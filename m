Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbZI2InZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbZI2InZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 04:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZI2InZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 04:43:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33005 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729AbZI2InY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 04:43:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AC1C889.705@jp.fujitsu.com>
Date: Tue, 29 Sep 2009 17:42:49 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] mce-inject: make injected mce valid only during faked
 handler call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com> <4AC05BBF.3010102@jp.fujitsu.com> <4AC05D48.1000007@jp.fujitsu.com> <4AC10588.90808@linux.intel.com>
In-Reply-To: <4AC10588.90808@linux.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> This has an undesired side-effect: it is possible for it to be
>> consumed by real machine_check_poll. This may confuse a real system
>> error and may confuse the mce test suite.
> 
> You can just disable the poll handler in the test suite. That's
> what we did.

I'd like to fix this simply, rather than providing documentation like
"you should turn off polling before you use the mce-inject."

>> The injectm.valid becomes "2" only during faked MCE handler call
>> and protected by IRQ disabling. This make it impossible for real
>> machine_check_poll to consume it.
> 
> Using magic numbers for this seems very hackish.

Right.  I'll take other approach in next time.


Thanks,
H.Seto

