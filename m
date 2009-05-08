Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbZEHLXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbZEHLXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753201AbZEHLX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:23:28 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:54885 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbZEHLX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:23:27 -0400
Message-ID: <4A041625.5060408@linux.vnet.ibm.com>
Date: Fri, 08 May 2009 13:23:17 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
References: <20090507124556.041286732@linux.vnet.ibm.com>  <20090507124557.003153444@linux.vnet.ibm.com>  <20090507125332.GM28398@elte.hu> <4A02E445.7070201@linux.vnet.ibm.com> <20090507134813.GO28398@elte.hu>
In-Reply-To: <20090507134813.GO28398@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>> Ingo Molnar wrote:
>>> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>>>
>>>> Disable constructor support for usermode Linux to prevent conflicts
>>>> with host glibc.
>>>> +++ linux-2.6.30-rc4/init/Kconfig
>>>> @@ -16,6 +16,11 @@ config DEFCONFIG_LIST
>>>>  	default "$ARCH_DEFCONFIG"
>>>>  	default "arch/$ARCH/defconfig"
>>>>  +config CONSTRUCTORS
>>>> +	bool
>>>> +	depends on !UML
>>>> +	default y
>>>> +
>>>>  menu "General setup"
>>> Hm, excluding UML like that is sad. Is there no better solution?
>> UML is excluded because in that environment constructors are 
>> called by the host glibc, so there is no need for kernel support 
>> on UML (in fact it would break things).
>>
>> Or were you referring to the actual way the exclusion is 
>> implemented?
> 
> the way it's done is OK (there's really just UML in this situation), 
> but the question is really, shouldnt it be possible to coverage-test 
> UML instances 'from the inside'?

 From a mere gcov perspective, coverage-testing from the outside is 
superior because that is the way it was meant to be run in the first place.

> 
> Plus, if any other kernel facility grows out of this or makes use of 
> it, UML will be left out in the cold.

I'm afraid that trying to over-engineer the gcov-kernel mechanism at 
this time might serve neither the gcov-kernel users, nor potential new 
users. Once the base is established, it will be far easier to decide 
which other purposes the infrastructure can serve (without completely 
bending it).

