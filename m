Return-Path: <linux-kernel-owner+w=401wt.eu-S1760336AbZJIIcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760336AbZJIIcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758446AbZJIIcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:32:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60520 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760158AbZJIIcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:32:09 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4ACEF4D9.9090600@jp.fujitsu.com>
Date: Fri, 09 Oct 2009 17:31:21 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked handler
 call
References: <1254100882.15717.1312.camel@yhuang-dev.sh.intel.com>	 <4AC95F5A.4000708@jp.fujitsu.com>  <4AC96391.1060001@jp.fujitsu.com>	 <1255072482.5228.157.camel@yhuang-dev.sh.intel.com>	 <4ACEE5E0.3050701@jp.fujitsu.com> <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>
In-Reply-To: <1255074286.5228.163.camel@yhuang-dev.sh.intel.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Huang Ying wrote:
> On Fri, 2009-10-09 at 15:27 +0800, Hidetoshi Seto wrote: 
>> Huang Ying wrote:
>>> This is another example for you to use my idea, implement it in a
>>> similar way and send it out as your own.
>> I used "Reported-by:" for this patch, having some intent to indicate
>> that this patch uses an idea different from the original one, and that
>> this patch aims at the problem certainly reported by you.
> 
> The point of the idea is to use two flags instead of one flag, not the
> name of the flag or they are inside/outside of struct mce.

Humm, I could be wrong and could misread your comment...

The point of my idea is to use two separated flags, "inject_flags" for
inject tool and "valid" for kernel, instead of one flag as you proposed,
"inject_flags" shared by both. 
And I think the flag for kernel should be outside of struct mce.

Once I complained about the name of flag ".finished", because you were
trying to add "LOADED" flag.  I thought that "if .finished but !LOADED, it
means the loading data to struct is finished but not loaded.. ???what???"

So at first I tried to add 3rd state to ".finished", but soon I agreed
that it is not good idea.

After that I started to think about having two separated flags, and the
result is this [6/6] patch in -v2.

In short, I believe that my idea is "use two flags" and your idea is
"share one flag" ... right?


The only thing what I want to do here is merge your "fix" into upstream.


Thanks,
H.Seto

