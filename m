Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZKHRrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZKHRrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 12:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753953AbZKHRrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 12:47:01 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:52201 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZKHRrA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 12:47:00 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Nov 2009 12:47:00 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DRf6IzlqEgMpZNpzxl9FNLD52iFow12mqJEhdC54y1+pHxqOipaeOQPGMLqqbvqPzx
         7Pb12dInVCg6kSojE7EKtLiC7HQjJJ8qJxiTUtCxZ46F8CXYdAHuvzbrStbH4rvM6Kvg
         hihiT6qJ0N4kYbevFFOHa+3o/memWEGAO64sI=
MIME-Version: 1.0
In-Reply-To: <20091108173708.GF1372@ucw.cz>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> 
	<20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> 
	<4AF4526B.4060101@zytor.com> <40101cc30911061418w357b74d8i3bf9a9537de052d4@mail.gmail.com> 
	<20091108173708.GF1372@ucw.cz>
From: Matteo Croce <technoboy85@gmail.com>
Date: Sun, 8 Nov 2009 18:40:06 +0100
Message-ID: <40101cc30911080940s18eb26bbg641beeaddbc25c3d@mail.gmail.com>
Subject: Re: i686 quirk for AMD Geode
To: Pavel Machek <pavel@ucw.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 8, 2009 at 6:37 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Fri 2009-11-06 23:18:06, Matteo Croce wrote:
>> On Fri, Nov 6, 2009 at 5:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> > On 11/06/2009 06:59 AM, Matteo Croce wrote:
>> >> indeed it has MMX, MMXEXT and CMOV, just lacks the long NOP instruction (NOPL).
>> >
>> > MMX and MMXEXT are hardly hallmarks of i686, which leaves only cmov.
>> > I'm somewhat wondering about the general value of this patch; is i686
>> > code really that much faster on Geode that it's worth it?
>> >
>> > ? ? ? ?-hpa
>> >
>> > --
>> > H. Peter Anvin, Intel Open Source Technology Center
>> > I work for Intel. ?I don't speak on their behalf.
>> >
>> >
>>
>> yes, I did some test like gzip, bzip2, lame etc and they give more or less
>> the same results of dhrystone
>>
>> root@alix:/usr/src# CFLAGS='-march=i586' ./dry.c
>> Microseconds for one run through Dhrystone:        1.4
>> Dhrystones per Second:                          740741
> ...
>> root@alix:/usr/src# CFLAGS='-march=i686' ./dry.c
>> Trying 5000000 runs through Dhrystone:
>> Microseconds for one run through Dhrystone:        1.2
>> Dhrystones per Second:                          841751
>
> Teach gcc that geodelx exists? No need to break kernel for that... and
> you probably can gain even bigger gains.
>                                                                        Pavel

Gcc 4.4 already knows about it, just sucks at optimizing:

# CFLAGS='-march=geode' ./dry.c
gcc -c -O3 -march=geode ./dry.c -o dry1.o
gcc -DPASS2 -O3 -march=geode ./dry.c dry1.o  -o dry2

Dhrystone Benchmark, Version C, Version 2.2
Program compiled without 'register' attribute
Using times(), HZ=100

Trying 5000000 runs through Dhrystone:
Microseconds for one run through Dhrystone:        1.4
Dhrystones per Second:                          719424
