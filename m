Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZHEVRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZHEVRm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbZHEVRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:17:42 -0400
Received: from mail-yx0-f175.google.com ([209.85.210.175]:47071 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbZHEVRl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:17:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qtx0V9qL/RX0zgz8aj5wvT7+r8jHNokBypsVrNW6HBxFbEOhKBD2/R19CarXPMzOma
         lFwEpGPfXuoylbr7z5Tl29QWAmwSauOMpyXEylsg2AgGANu8GfkOKaTvGnLcZb7jbnU6
         Bc+t/BhUCFUb9M9c5k5RGsa7V6FrHDFGY4k0A=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0908050929460.21700@gandalf.stny.rr.com>
References: <21d7e9970908050013m71ce7500x1d04a591de21ca30@mail.gmail.com>
	 <alpine.DEB.2.00.0908050929460.21700@gandalf.stny.rr.com>
Date: Thu, 6 Aug 2009 07:17:38 +1000
Message-ID: <21d7e9970908051417p2560cc24w67a3cff8c6a6fc43@mail.gmail.com>
Subject: Re: Please revert fc4c73554c9d93b3e495f2f7acae1323b0d5db84. Re: 
	[PATCH 1/2] ftrace: Fix the conditional that updates $ref_func
From: Dave Airlie <airlied@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matt Fleming <matt@console-pimps.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@codemonkey.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 11:30 PM, Steven Rostedt<rostedt@goodmis.org> wrote:
>
> On Wed, 5 Aug 2009, Dave Airlie wrote:
>
>> On Fri, Jul 24, 2009 at 2:16 AM, Matt Fleming<matt@console-pimps.org> wrote:
>> > Fix the conditional that checks if we already have a $ref_func and that
>> > the new function is weak. The code as previously checking whether either
>> > condition was false, and we really need to only update $ref_func is both
>> > cconditions are false.
>> >
>>
>> This breaks the powerpc build on Fedora.
>>
>> When building on ppc64 this commit causes the links of drivers/hwmon/lm93.o
>> to fail.
>>
>> It introduces an undefined symbol
>>                  U .LM93_IN_FROM_REG
>>
>> that isn't produced when this patch is reverted
>>
>> This was found when the Fedora kernel failed to build when I pulled in
>> -rc5-git3.
>>
>> can be seen at the end of:
>> http://koji.fedoraproject.org/koji/getfile?taskID=1582002&name=build.log
>>
>> So can we revert this (at this stage in -rc5 or maybe fix it).
>
> I'll boot up my PPC64 box and see if I can reproduce. In the mean time,
> could you send me your config (privately)
>

http://people.freedesktop.org/~airlied/for_mfleming.tar.gz

has my config along with the stuff produced.

Dave.
