Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbZABKa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbZABKa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 05:30:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZABKaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 05:30:17 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:32778 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZABKaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 05:30:15 -0500
Cc: Christoph Hellwig <hch@infradead.org>,
       Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>
Message-Id: <865953A9-E699-45E1-A726-F3F4EE41A0C9@mirell.org>
From: Mark Miller <mark@mirell.org>
To: Alejandro Mery <amery@opensde.org>
In-Reply-To: <495DE995.1070002@opensde.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed; delsp=yes
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Fri, 2 Jan 2009 04:30:06 -0600
References: <200901020207.30359.rob@landley.net> <200901021026.37905.a.miskiewicz@gmail.com> <20090102094934.GB17841@infradead.org> <495DE995.1070002@opensde.org>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 2, 2009, at 4:16 AM, Alejandro Mery wrote:

> Christoph Hellwig escribió:
>> On Fri, Jan 02, 2009 at 10:26:37AM +0100, Arkadiusz Miskiewicz wrote:
>>
>>> On Friday 02 of January 2009, Rob Landley wrote:
>>>
>>>> Before 2.6.25 (specifically git  
>>>> bdc807871d58285737d50dc6163d0feb72cb0dc2 )
>>>> building a Linux kernel never required perl to be installed on  
>>>> the build
>>>> system.  (Various development and debugging scripts were written  
>>>> in perl
>>>> and python and such, but they weren't involved in actually  
>>>> building a
>>>> kernel.) Building a kernel before 2.6.25 could be done with a  
>>>> minimal
>>>> system built from gcc, binutils, bash, make, busybox, uClibc, and  
>>>> the Linux
>>>> kernel, and nothing else.
>>>>
>>> And now bash is going to be required... while some distros don't  
>>> need/have
>>> bash. /bin/sh should be enough.
>>>
>>
>> *nod*  bash is in many ways a worse requirement than perl.  strict  
>> posix
>> /bin/sh + awk + sed would be nicest, but if that's too much work perl
>> seems reasonable.

>>
> well, bash is not worse as bash is trivial to cross-compile to run  
> on a
> constrained sandbox and perl is a nightmare, but I agree bash should  
> be
> avoided too.
>
> I think the $(( ... )) bash-ism can be replaced with a simple .c  
> helper toy.
>
> Thank Rob for reopening the topic.
>
> Alejandro Mery

And actually, one of the things that I just recalled, is that several  
of the Perl configure scripts in order to actually build itself, rely  
on Bourne shell calls. So the argument to require a strict POSIX+sed 
+awk implementation rather than Perl to build the kernel, fails, since  
you already require some variant of shell greater than strict POSIX / 
bin/sh to build Perl. So this is one less dependency.

Also, attempting to cross-compile Perl, is indeed a nightmare.

--
Mark Miller
mark@mirell.org




