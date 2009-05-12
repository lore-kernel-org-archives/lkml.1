Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbZELNNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbZELNNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbZELNNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:13:04 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:38101 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZELNNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:13:02 -0400
Message-ID: <4A0975D0.1030407@linux.vnet.ibm.com>
Date: Tue, 12 May 2009 15:12:48 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Li Wei <W.Li@Sun.COM>, Michael Ellerman <michaele@au1.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH 1/4] kernel: constructor support
References: <20090508154407.956216094@linux.vnet.ibm.com>  <20090508154408.925135176@linux.vnet.ibm.com> <20090509050335.GC18129@hack>  <4A07E536.9070609@linux.vnet.ibm.com> <20090511185424.GA32234@uranus.ravnborg.org>
In-Reply-To: <20090511185424.GA32234@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, May 11, 2009 at 10:43:34AM +0200, Peter Oberparleiter wrote:
>> Américo Wang wrote:
>>> On Fri, May 08, 2009 at 05:44:09PM +0200, Peter Oberparleiter wrote:
>>>> From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
>>>> Index: linux-2.6.30-rc4/init/main.c
>>>> ===================================================================
>>>> --- linux-2.6.30-rc4.orig/init/main.c
>>>> +++ linux-2.6.30-rc4/init/main.c
>>>> @@ -700,6 +700,18 @@ asmlinkage void __init start_kernel(void
>>>> 	rest_init();
>>>> }
>>>>
>>>> +/* Call all constructor functions linked into the kernel. */
>>>> +static void __init do_ctors(void)
>>>> +{
>>>> +#ifdef CONFIG_CONSTRUCTORS
>>>> +	extern ctor_fn_t __ctors_start[], __ctors_end[];
>>>
>>> I would like these to be globally decleared, since they are.
>> Ok, I will move the __ctors_* declarations to include/linux/ínit.h
> 
> include/asm-generic/sections.h please.
> And please add a comment too.

Ok. I'm also assuming that the preferred type declaration for section 
boundaries defined in sections.h would be char[] so I'm changing that as 
well.

Updated patch set to follow. Thanks.

