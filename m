Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171Ab0ATWJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0ATWJn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 17:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361Ab0ATWJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 17:09:42 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35605 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439Ab0ATWJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 17:09:41 -0500
Message-ID: <4B577F1A.9060907@austin.ibm.com>
Date: Wed, 20 Jan 2010 16:09:30 -0600
From: Joel Schopp <jschopp@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
       ego@in.ibm.com
Subject: Re: [PATCH 2/2] powerpc: implement arch_scale_smt_power for Power7
References: <1264017638.5717.121.camel@jschopp-laptop> <1264017847.5717.132.camel@jschopp-laptop> <26556.1264021443@neuling.org>
In-Reply-To: <26556.1264021443@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +	if (cpu_has_feature(CPU_FTRS_POWER7) && weight == 4) {
>>     
>
> I think we should avoid using cpu_has_feature like this.  It's better to
> create a new feature and add it to POWER7 in the cputable, then check
> for that here.
>
> The way that it is now, I think any CPU that has superset of the POWER7
> features, will be true here.  This is not what we want.
>   
Any ideas for what to call this feature?  ASYM_SMT4 ?
>
>> +	smt_gain /= weight;
>>     
>
> This results in a PPC div, when most of the time it's going to be a
> power of two divide.  You've optimised the divides a few lines above
> this, but not this one.  Some consistency would be good.
>
>   
I can turn that into a conditional branch (case statement) with a shift 
for the common 1,2,4 cases which should cover all procs available today 
falling back to a divide for any theoretical future processors that do 
other numbers of threads.
