Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZEGNuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZEGNuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 09:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbZEGNtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:49:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60152 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZEGNtu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:49:50 -0400
Date: Thu, 7 May 2009 15:48:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
Message-ID: <20090507134813.GO28398@elte.hu>
References: <20090507124556.041286732@linux.vnet.ibm.com> <20090507124557.003153444@linux.vnet.ibm.com> <20090507125332.GM28398@elte.hu> <4A02E445.7070201@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A02E445.7070201@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> Ingo Molnar wrote:
>> * Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
>>
>>> Disable constructor support for usermode Linux to prevent conflicts
>>> with host glibc.
>>
>>> +++ linux-2.6.30-rc4/init/Kconfig
>>> @@ -16,6 +16,11 @@ config DEFCONFIG_LIST
>>>  	default "$ARCH_DEFCONFIG"
>>>  	default "arch/$ARCH/defconfig"
>>>  +config CONSTRUCTORS
>>> +	bool
>>> +	depends on !UML
>>> +	default y
>>> +
>>>  menu "General setup"
>>
>> Hm, excluding UML like that is sad. Is there no better solution?
>
> UML is excluded because in that environment constructors are 
> called by the host glibc, so there is no need for kernel support 
> on UML (in fact it would break things).
>
> Or were you referring to the actual way the exclusion is 
> implemented?

the way it's done is OK (there's really just UML in this situation), 
but the question is really, shouldnt it be possible to coverage-test 
UML instances 'from the inside'?

Plus, if any other kernel facility grows out of this or makes use of 
it, UML will be left out in the cold.

	Ingo
