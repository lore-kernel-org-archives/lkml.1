Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374Ab0AMXOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab0AMXOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752352Ab0AMXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:14:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36173 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0AMXOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:14:37 -0500
Message-ID: <4B4E5390.1070004@zytor.com>
Date: Wed, 13 Jan 2010 15:13:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Suresh Siddha <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2 5/5] x86: use dmi check to treat disabled cpus as
 hotplug cpus.
References: <1263338274-6485-1-git-send-email-yinghai@kernel.org>	 <1263338274-6485-5-git-send-email-yinghai@kernel.org>	 <1263340563.2854.1011.camel@sbs-t61.sc.intel.com>	 <4B4D0E39.10200@kernel.org> <87tyupfzk8.fsf@basil.nowhere.org>	 <4B4E427D.9090207@zytor.com> <20100113222348.GE24818@basil.fritz.box>	 <4B4E48BB.5030902@zytor.com>	 <1263421753.2865.103.camel@sbs-t61.sc.intel.com>	 <4B4E4AE3.1030608@zytor.com> <1263422958.2865.107.camel@sbs-t61.sc.intel.com> <4B4E511C.1050609@kernel.org>
In-Reply-To: <4B4E511C.1050609@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2010 03:02 PM, Yinghai Lu wrote:
> On 01/13/2010 02:49 PM, Suresh Siddha wrote:
>> On Wed, 2010-01-13 at 14:36 -0800, H. Peter Anvin wrote:
>>> On 01/13/2010 02:29 PM, Suresh Siddha wrote:
>>>>>
>>>>> Well, that *is* working around broken code, in this case the broken code
>>>>> is the percpu allocation strategy.
>>>>
>>>> Andi, Recently percpu folks changed the per-cpu static first chunk to
>>>> PMD SIZE right. I think that is what causing all this issue.
>>>>
>>>
>>> Please don't tell me we're allocating 2 MB per CPU and throwing away
>>> most of it...
>>
>> Looking at the percpu code, they do seem to free the unused memory in
>> that hole.
>>
>> Yinghai, what are the configurations that need MB's of per cpu area?
> 
> please check attached...
> 

I just built an allyesconfig kernel, and it has 1904K of percpu data.
1791K of that is in per_cpu__cpu_lock_stats.  So everything else is
~113K.  Still.  We should not be restricted from doing legitimately
large percpu allocations because of ghost cpus (and Tejun knows my
position on this), but it doesn't sound like the house is burning, either.

	-hpa
