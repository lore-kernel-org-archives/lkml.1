Return-Path: <linux-kernel-owner+w=401wt.eu-S1758278AbZEGNkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278AbZEGNkA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758764AbZEGNiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:38:20 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:43594 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757487AbZEGNiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:38:18 -0400
Message-ID: <4A02E445.7070201@linux.vnet.ibm.com>
Date: Thu, 07 May 2009 15:38:13 +0200
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
References: <20090507124556.041286732@linux.vnet.ibm.com>  <20090507124557.003153444@linux.vnet.ibm.com> <20090507125332.GM28398@elte.hu>
In-Reply-To: <20090507125332.GM28398@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> 
>> Disable constructor support for usermode Linux to prevent conflicts
>> with host glibc.
> 
>> +++ linux-2.6.30-rc4/init/Kconfig
>> @@ -16,6 +16,11 @@ config DEFCONFIG_LIST
>>  	default "$ARCH_DEFCONFIG"
>>  	default "arch/$ARCH/defconfig"
>>  
>> +config CONSTRUCTORS
>> +	bool
>> +	depends on !UML
>> +	default y
>> +
>>  menu "General setup"
> 
> Hm, excluding UML like that is sad. Is there no better solution?

UML is excluded because in that environment constructors are called by 
the host glibc, so there is no need for kernel support on UML (in fact 
it would break things).

Or were you referring to the actual way the exclusion is implemented?

