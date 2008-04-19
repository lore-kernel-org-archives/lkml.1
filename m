Return-Path: <linux-kernel-owner+w=401wt.eu-S1759808AbYDSCWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759808AbYDSCWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 22:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759014AbYDSCVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 22:21:52 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54202 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759011AbYDSCVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 22:21:51 -0400
Message-ID: <4809573E.4010406@sgi.com>
Date: Fri, 18 Apr 2008 19:21:50 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up non-smp usage of cpu maps
References: <200804181736.m3IHatLo009568@hera.kernel.org> <20080418184921.87934c3f.akpm@linux-foundation.org>
In-Reply-To: <20080418184921.87934c3f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 18 Apr 2008 17:36:55 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:
> 
>>     x86: clean up non-smp usage of cpu maps
>>     
>>     Cleanup references to the early cpu maps for the non-SMP configuration
>>     and remove some functions called for SMP configurations only.
>>     
>> ...
>>
>> index 1179aa0..dc79409 100644
>> --- a/arch/x86/kernel/setup.c
>> +++ b/arch/x86/kernel/setup.c
>> @@ -10,7 +10,7 @@
>>  #include <asm/setup.h>
>>  #include <asm/topology.h>
>>  
>> -#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
>> +#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
> 
> This implies that we can have
> 
> 	CONFIG_HAVE_SETUP_PER_CPU_AREA && !CONFIG_SMP
> 
> which a) appears to be true and b) seems rather dumb?

Yeah, I kind of picked that up in a code merge and didn't really look at it
too closely.  I should have checked the Kconfig file to make sure that it
couldn't inadvertently get set if SMP is not set.

Thanks,
Mike
