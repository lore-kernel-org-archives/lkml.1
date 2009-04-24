Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZDXH3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZDXH3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 03:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbZDXH3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 03:29:30 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52115 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbZDXH33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 03:29:29 -0400
Message-ID: <49F16A38.1030306@jp.fujitsu.com>
Date: Fri, 24 Apr 2009 16:28:56 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Andi Kleen <andi@firstfloor.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>
Subject: Re: [PATCH] [3/4] x86: MCE: Improve mce_get_rip
References: <20090407506.675031434@firstfloor.org>	 <20090407150656.43E161D046D@basil.firstfloor.org>	 <49DC5D11.4060505@jp.fujitsu.com>	 <1240479833.6842.554.camel@yhuang-dev.sh.intel.com>	 <49F15922.5090704@jp.fujitsu.com> <1240554911.6842.880.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1240554911.6842.880.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Fri, 2009-04-24 at 14:16 +0800, Hidetoshi Seto wrote:
>> One question is: if (RIPV,EIPV) = (0,0), then is the IP on the stack
>> really invalid value, or is it still point IP when MCE is generated?
>> I suppose it is not invalid.  If a processor encounters MCE and if it
>> is not sure what happened, then it will store the IP on the stack,
>> indicating neither of flags.
>>
>> If this supposition is correct, the best way is pick the value on
>> the stack unconditionally, and record valid flags together.
> 
> According to spec, the IP on stack can be not related to MCE if
> (RIPV,EIPV) = (0,0). So it is meaningless to report them. If you report
> them unconditionally, you just push the logic to user space or
> administrator.

Sorry, I could not find good page in the spec (Intel64 and IA-32 ASDM)...
Could you point one?

I believe that the IP with (RIPV,EIPV) = (1,0) is "not associated with the
error" too, so is it meaningless to report the IP?
If you think so then correct fix is replacing RIPV check by EIPV check.

>From another point of view, the reported IP will be one of followings:
  - IP that associated with error (= related to MCE)
  - IP that the interrupted program can restart from
  - IP that when MCE is generated
Are there no way to distinguish them in user space?
And which is the one that we must report to the user space?
Which is one that must not?

You stated in the description of this patch:
> mce_get_rip() is used to get IP when MCE is generated,
Is this right?

If we have no answer here, we should report the IP unconditionally,
not to lost any error information.


Thanks,
H.Seto

