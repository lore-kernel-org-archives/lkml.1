Return-Path: <linux-kernel-owner+w=401wt.eu-S1751855AbZLRGBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751855AbZLRGBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 01:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZLRGBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 01:01:06 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:47588 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZLRGBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 01:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=k/ulUZ9wQ3ay8OIAagv5WJ5iAlDjcqYxgmLbiLcvh6kWVbkz/pBmwbxu+OK+KNkATx
         IzUkUlLBn34heFKTsl09lLQRf58sfJzO81yiXj/pxMHDepHDfXP+d+BhnPxPAkJNyZI8
         6pari+xek10149z6l2nXRnF/qU6tEpLGv3Fgs=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.0912172045360.9874@filesrv1.baby-dragons.com>
References: <alpine.LNX.2.01.0912171418380.9874@filesrv1.baby-dragons.com>
	 <alpine.LNX.2.01.0912172045360.9874@filesrv1.baby-dragons.com>
Date: Fri, 18 Dec 2009 14:01:03 +0800
Message-ID: <2375c9f90912172201p53159fe2k7e5ddf6d5c872ad9@mail.gmail.com>
Subject: Re: [kernel] linux-2.6.32.1 "make V=1 menuconfig" errors , Huh ?-(
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Cc: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 1:50 PM, Mr. James W. Laferriere
<babydr@baby-dragons.com> wrote:
>                Hello All ,
>
> On Thu, 17 Dec 2009, Mr. James W. Laferriere wrote:
>>
>>        Some pertinant info ...
>> # scripts/ver_linux
>> If some fields are empty or look unusual you may have an old version.
>> Compare to the current minimal requirements in Documentation/Changes.
>>
>> Linux (none) 2.6.30.6 #1 SMP Sun Oct 11 18:36:23 UTC 2009 i686 pentium4
>> i386 GNU/Linux
>>
>> Gnu C                  3.4.6
>> Gnu make               3.81
>> binutils               2.15.92.0.2
>> util-linux             2.12r
>> mount                  2.12r
>> module-init-tools      3.2.2
>> e2fsprogs              1.38
>> jfsutils               1.1.11
>> reiserfsprogs          3.6.19
>> xfsprogs               2.8.10
>> pcmciautils            014
>> pcmcia-cs              3.2.8
>> quota-tools            3.13.
>> PPP                    2.4.4
>> Linux C Library        2.3.6
>> Dynamic linker (ldd)   2.3.6
>> Linux C++ Library      6.0.3
>> Procps                 3.2.7
>> Net-tools              1.60
>> Kbd                    1.12
>> oprofile               0.9.1
>> Sh-utils               5.97
>> udev                   097
>> Modules Loaded
>>
>>        The errors ,  Quite a mouth full of them .  NEVER seen menuconfig
>> spit all this sh?t out before .
>>        Can someone enlighten me as to what I've got that is broken or ...
>> ?
>>                        Tia ,  JimL
>> # make V=1 menuconfig
>> make -f scripts/Makefile.build obj=scripts/basic
>>  gcc -Wp,-MD,scripts/basic/.fixdep.d -Wall -Wmissing-prototypes
>> -Wstrict-prototypes -O2 -fomit-frame-pointer     -o scripts/basic/fixdep
>> scripts/basic/fixdep.c
>> In file included from scripts/basic/fixdep.c:106:
>> /usr/include/sys/types.h:27:22: features.h: No such file or directory
>> In file included from /usr/include/bits/types.h:31,
>>                from /usr/include/sys/types.h:31,
>>                from scripts/basic/fixdep.c:106:
>> /usr/lib/gcc/i486-slackware-linux/3.4.6/include/stddef.h:213: error:
>> syntax error before "typedef"
>> /usr/include/sys/types.h:133:18: time.h: No such file or directory
>> /usr/include/sys/types.h:158:20: missing binary operator before token "("
>> In file included from scripts/basic/fixdep.c:107:


You lost your /usr/include/features.h which is provided by glibc-headers.

>
>        For someone elses benefit these are symptomatic of butchered header
> file directory contents .  Cure was to reinstall the base header file
> packages .
>        This was caused by an attempt (2.6.28 days) to do a "make
> INSTALL_HDR_PATH=/usr headers_install" which was uneducated .  And still do
> NOT see a document covering WHEN such a header install would/should be
> necessary .
>        If I am just being blind PLEASE guide me to the document in the
> kernel tree so I can rectify my ignorance .
>

Kernel headers are used when you build glibc package, not intended for
other use, I think.
