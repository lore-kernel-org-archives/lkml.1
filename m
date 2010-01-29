Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712Ab0A2Slr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab0A2Slr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636Ab0A2Slq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:41:46 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33627 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630Ab0A2Slq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:41:46 -0500
Message-ID: <4B632BE2.9020106@austin.ibm.com>
Date: Fri, 29 Jan 2010 12:41:38 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop>	 <1264017847.5717.132.camel@jschopp-laptop>	 <1264548495.12239.56.camel@jschopp-laptop>	 <1264720855.9660.22.camel@jschopp-laptop>	 <1264721088.10385.1.camel@jschopp-laptop> <1264728185.20211.34.camel@pasglop>
In-Reply-To: <1264728185.20211.34.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Thu, 2010-01-28 at 17:24 -0600, Joel Schopp wrote:
>   
>> On Power7 processors running in SMT4 mode with 2, 3, or 4 idle threads 
>> there is performance benefit to idling the higher numbered threads in
>> the core.  
>>
>> This patch implements arch_scale_smt_power to dynamically update smt
>> thread power in these idle cases in order to prefer threads 0,1 over
>> threads 2,3 within a core.
>>     
>
> Almost there :-) Joel, Peter, can you help me figure something out tho ?
>
> On machine that don't have SMT, I would like to avoid calling
> arch_scale_smt_power() at all if possible (in addition to not compiling
> it in if SMT is not enabled in .config).
>
> Now, I must say I'm utterly confused by how the domains are setup and I
> haven't quite managed to sort it out... it looks to me that
> SD_SHARE_CPUPOWER is always going to be set on all CPUs when the config
> option is set (though each CPU will have its own domain) or am I
> misguided ? IE. Is there any sense in having at least a fast exit path
> out of arch_scale_smt_power() for non-SMT CPUs ?
>
> Joel, can you look at compiling it out when SMT is not set ? We don't
> want to bloat SMP kernels for 32-bit non-SMT embedded platforms.
>   
I can wrap the powerpc definition of arch_scale_smt in an #ifdef, if 
it's not there the scheduler uses the default, which is the same as it 
uses if SMT isn't compiled. 


