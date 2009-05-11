Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZEKNRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZEKNRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZEKNRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:17:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35990 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbZEKNRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:17:21 -0400
Date: Mon, 11 May 2009 15:17:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-ID: <20090511131708.GB32693@elte.hu>
References: <20090507124556.041286732@linux.vnet.ibm.com> <20090507124558.618214093@linux.vnet.ibm.com> <20090507134610.GN28398@elte.hu> <4A04133B.8080501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A04133B.8080501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

>>> +/* __gcov_init is called by gcc-generated constructor code for each object
>>> + * file compiled with -fprofile-arcs. */
>>
>> Please use standard multi-line comments like specified in  
>> Documentation/CodingStyle. This observation holds for basically all  
>> the comment blocks in this file - dozens of them.
>
> None of the __gcov functions are ever called by the kernel 
> directly - only by gcc generated code. I can add comments for 
> __gcov_init as that one is actually implemented. The other 
> functions are required to prevent linking errors but are never 
> actually called in kernel context, therefore in my opinion it 
> wouldn't make much sense to provide full-blown comments for them.

It isnt about the amount of comments, it is about the plain (and 
simple to rectify) fact that the above two-lines comment is 
inconsistent with other kernel code.

>>>                   $(asflags-y) $(AFLAGS_$(basetarget).o)
>>>  _cpp_flags     = $(KBUILD_CPPFLAGS) $(cppflags-y) $(CPPFLAGS_$(@F))
>>>  +# Enable gcov profiling flags for a file, directory or for all 
>>> files depending
>>> +# on variables GCOV_PROFILE_obj.o, GCOV_PROFILE and CONFIG_GCOV_PROFILE_ALL
>>> +# (in this order)
>>> +ifeq ($(CONFIG_GCOV_KERNEL),y)
>>
>> Please try to use winged comments in makefiles too.
>
> What do you mean by winged comments?

This:

  /*
   * Comment .....
   * ...... goes here:
   */

Is called a winged comment. Its makefile equivalent is:

   #
   # Comment .........
   # ....... goes here
   #

        Ingo
