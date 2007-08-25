Return-Path: <linux-kernel-owner+w=401wt.eu-S1765416AbXHYN5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765416AbXHYN5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 09:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXHYN44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 09:56:56 -0400
Received: from gate.crashing.org ([63.228.1.57]:55635 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbXHYN4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 09:56:55 -0400
In-Reply-To: <20070825130210.GC15183@uranus.ravnborg.org>
References: <20070820213259.956EB4D05F4@magilla.localdomain> <533f74c072dc11b514fe4dc87fd7edc5@kernel.crashing.org> <20070825130210.GC15183@uranus.ravnborg.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <a113ea3591b48381b12f50dea9de29d4@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Roland McGrath <roland@redhat.com>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [POWERPC] Fix for assembler -g
Date: Sat, 25 Aug 2007 15:56:39 +0200
To: Sam Ravnborg <sam@ravnborg.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> But there is no lparmap.o!  lparmap.s is the generated file.
>>>
>>> Yeah, tell that to scripts/Makefile.lib:
>>>
>>> 	_c_flags       = $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$(basetarget).o)
>>>
>>> What would do what a person expects is $(CFLAGS_$(@F)), I think.
>>
>> Looks good to me.  Sam?  We wanted to set CFLAGS_lparmap.s .
>
> To avoid confusion (in most cases) setting CFLAGS_file.o
> does the expected thing in case on .o, .s, .lst and .i targets.
> So the general and easy to remember rule is to set CFLAGS_file.o
> and then kbuild takes care of the rest.

Yeah, that makes sense in the "normal" case.  In this case, the
generated .s file is actually used in the build process though,
so it was a bit confusing.

> I assume you already did so and it solved your problem - no?

Sure, it was just a question "is this the right thing or not".
In any case, the problematic thing will be removed completely
here :-)

Thanks for the explanation, it all makes sense now,


Segher

