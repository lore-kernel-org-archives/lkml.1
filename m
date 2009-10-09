Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbZJIFjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbZJIFjL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 01:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbZJIFjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 01:39:08 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:53984 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZJIFjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 01:39:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACECC49.7000602@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 14:38:17 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked handler
 call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com> <1255053299.5228.28.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1255053299.5228.28.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Mon, 2009-10-05 at 11:10 +0800, Hidetoshi Seto wrote: 
>> +/*
>> + * For error injection
>> + */
>> +
>> +struct mce_fake_banks {
>> +	int valid;
>> +	struct mce injectm;
>> +};
> 
> There are some bits available in mce.inject_flags. I don't think it is
> necessary to add another variable just for another flag.

I disagreed.  I think it is necessary.

If we try to support injecting multiple event to a cpu, we should have a flag
like this sooner or later.  Or we have to manage injectm[].inject_flags.

And I think the inject_flags should not have bits for kernel internal use.
All bits in inject_flags should be used by tools to tell attributes of data
injected with the flag.

As a sample I made an additional patch set to support injecting multiple event
to a CPU.  These change doesn't break current functionality.
Some improve will be required on mce-inject tool to use this feature.

Check my patches and comment on it.


Thanks,
H.Seto

