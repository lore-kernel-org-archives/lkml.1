Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZEZQm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZEZQm4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbZEZQmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:42:49 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:4079 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbZEZQms convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EE9fgOKRHSuNM93Vx6yMnOGwqDT3hOC+254k7NU4fU0UUswW1IuHRFICoU29dwdrBS
         +YmndnqDk8eKoQfGkOWWE7kRK3zmCtdAQe2AeBC6yGaC2b4Xx+GsFVlRk2ZB9beQqhm0
         TuyTqPW6EMTvKreUq3+jX6yv2FJo+YBFDq8Kw=
MIME-Version: 1.0
In-Reply-To: <20090526113122.GB16835@linux-sh.org>
References: <1243331191-11445-1-git-send-email-vapier@gentoo.org>
	 <1243331191-11445-2-git-send-email-vapier@gentoo.org>
	 <20090526113122.GB16835@linux-sh.org>
Date: Tue, 26 May 2009 12:42:48 -0400
Message-ID: <8bd0f97a0905260942m4b574d75oc4f38ee3d8849395@mail.gmail.com>
Subject: Re: [PATCH 2/2] mtd/maps: uclinux: support Blackfin systems
From: Mike Frysinger <vapier.adi@gmail.com>
To: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       uclinux-dist-devel@blackfin.uclinux.org,
       Greg Ungerer <gerg@uclinux.org>, uclinux-dev@uclinux.org,
       linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 07:31, Paul Mundt wrote:
> On Tue, May 26, 2009 at 05:46:31AM -0400, Mike Frysinger wrote:
>> diff --git a/drivers/mtd/maps/uclinux.c b/drivers/mtd/maps/uclinux.c
>> index 57699c2..dcb552f 100644
>> --- a/drivers/mtd/maps/uclinux.c
>> +++ b/drivers/mtd/maps/uclinux.c
>> @@ -55,8 +55,13 @@ static int __init uclinux_mtd_init(void)
>>  {
>>       struct mtd_info *mtd;
>>       struct map_info *mapp;
>> +#ifdef CONFIG_BLACKFIN
>> +     extern unsigned long memory_mtd_start;
>> +     unsigned long addr = (unsigned long) memory_mtd_start;
>> +#else
>>       extern char _ebss;
>>       unsigned long addr = (unsigned long) &_ebss;
>> +#endif
>>
>>       mapp = &uclinux_ram_map;
>>       mapp->phys = addr;
>
> NAK.
>
> I know there's no accounting for taste, but it would be nice to at least
> see some minimal amount of effort going in to fixing these things
> sanely rather than just lazily shoving ifdefs in wherever possible.
>
> In this case you should just kill all of that crap off, and have the
> platforms that use this set uclinux_ram_map up themselves, it's already
> a global. Of course you can use _ebss as a default value for
> uclinux_ram_map.phys and just override it in your platform.

i would agree if it were a board-specific issue, but it's an arch
issue, so pushing it to the boards level is wrong.  i can however
replace the addr with a global weak and add a symbol into the Blackfin
arch code to override it.

the structs being global in this file is simply wrong from what i can
tell ... everything in there should be static.  i'll send a patch for
that later on.
-mike
