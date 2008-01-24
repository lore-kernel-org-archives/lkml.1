Return-Path: <linux-kernel-owner+w=401wt.eu-S1758696AbYAXVmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbYAXVmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 16:42:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbYAXVlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 16:41:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46098 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbYAXVly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 16:41:54 -0500
Message-ID: <479904DF.60305@zytor.com>
Date: Thu, 24 Jan 2008 13:36:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       Andreas Herrmann3 <andreas.herrmann3@amd.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug fixes
References: <20080116023955.597433000@intel.com>	<20080116185748.GA11244@alberich.amd.com>	<20080116203328.GA17869@linux-os.sc.intel.com>	<20080117191211.GA12631@alberich.amd.com>	<20080117203600.GB27778@elte.hu>	<20080117210301.GC12631@alberich.amd.com>	<20080117211308.GA7858@elte.hu>	<20080117213131.GA25389@linux-os.sc.intel.com>	<478FCAD8.2020904@zytor.com> <m1lk6fht38.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1lk6fht38.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>
>>    | WB  WT  WC  UC
>> ---+---------------
>> WB | WB  WT  WC  UC
>> WT | WT  WT  UC  UC
>> WC | WC  UC  WC  UC
>> UC | UC  UC  UC  UC
>>
>> With the current PAT encoding:
>>
>> WB = 00
>> WT = 01
>> WC = 10
>> UC = 11
>>
>> ... this is simply a bitwise OR.  This makes sense, since one of the bits denies
>> delaying writes (WT, UC), and the other denies delaying reads (WC, UC).
> 
> Almost.  There is a specific case and important where MTRR UC + page table WC == WC.
> 
> But yes.  For ioremap where we are WB + MTRR == MTRR we need to request the
> same attributes as the e820 map, to get the attribute checking correct.
> 

True; however, that shouldn't be followed for the case of conflicting 
attempts at mapping.

Now, I *believe* it is safe to have some mappings UC and some WC.  This 
is also something to keep in mind (there are legitimate applications for 
that particular form of aliasing, too.)  If so, we may not want to thump 
at those.

	-hpa
