Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbZGTIYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbZGTIYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 04:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZGTIYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 04:24:48 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:60245 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbZGTIYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 04:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Dp4Ejxyj7sCo7RDbsIwalYpdOQL9ioOURMOgeJ+4qE+chWwIIiKp97qBcq4tHgXusY
         NImKTNv3ZL02eAjco15w6waTuARFMnN2M7VojqyHB/mTpXLrHlxTHdlxsZgej6KIC6FM
         D6pMLC14FYW/aSLbiv64eLtlmQ4e8MEviuNmY=
MIME-Version: 1.0
In-Reply-To: <1247808825.674.4.camel@work-vm>
References: <1244758210.7192.5.camel@localhost.localdomain> 
	<1247790356.7398.14.camel@localhost.localdomain> <8bd0f97a0907161926j258da72cg9dd1ca76ea8be2fb@mail.gmail.com> 
	<1247808825.674.4.camel@work-vm>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 20 Jul 2009 04:24:27 -0400
Message-ID: <8bd0f97a0907200124l403aaf9bv4a490e03e8ff9837@mail.gmail.com>
Subject: Re: [PATCH] Convert blackfin to use arch_gettimeoffset()
To: john stultz <johnstul@us.ibm.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 01:33, john stultz wrote:
> On Thu, 2009-07-16 at 22:26 -0400, Mike Frysinger wrote:
>> On Thu, Jul 16, 2009 at 20:25, john stultz wrote:
>> > This patch converts blackfin to use GENERIC_TIME via the arch_getoffset()
>> > infrastructure, reducing the amount of arch specific code we need to
>> > maintain.
>> >
>> > This patch applies on top of Linus' current -git tree (2.6.31-rc3).
>> >
>> > I've taken my best swing at converting this, but I'm not 100% confident
>> > I got it right. My cross-compiler is now out of date (gcc4.2) so I
>> > wasn't able to  check if it compiled. Any assistance from arch
>> > maintainers or testers to get this merged would be great.
>>
>> something seems to be off as the Blackfin defconfig now does:
>>   LD      .tmp_vmlinux1
>> kernel/built-in.o: In function `clocksource_forward_now':
>> kernel/time/timekeeping.c:82: undefined reference to `arch_gettimeoffset'
>> kernel/built-in.o: In function `getnstimeofday':
>> kernel/time/timekeeping.c:119: undefined reference to `arch_gettimeoffset'
>> make: *** [.tmp_vmlinux1] Error 1
>>
>> most likely because the Blackfin time.c is the old stuff
>> (non-clocksource) while time-ts.c is the newer stuff (clocksource) and
>> this change only touches time.c
>
> Ok. So I guess I missed that time.c isn't built if GENERIC_CLOCKEVENTS
> isn't enabled, so ARCH_HAS_GETTIMEOFFSET needs to depend on !
> GENERIC_CLOCKEVENTS.
>
> Hopefully I've got it cleared up now. Let me know if I'm still causing
> trouble.

this one seems to build & boot for GENERIC_CLOCKEVENTS set to y or n.  thanks.
-mike
