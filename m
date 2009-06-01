Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZFAHoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZFAHoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZFAHoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:44:37 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:59399 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbZFAHog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:44:36 -0400
Message-ID: <4A2386DD.5030302@petalogix.com>
Date: Mon, 01 Jun 2009 09:44:29 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Mundt <lethal@linux-sh.org>, jw@emlix.com, os@emlix.com,
       dhowells@redhat.com, rmk@arm.linux.org.uk, cooloney@kernel.org,
       geert@linux-m68k.org, vapier.adi@gmail.com, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v3] flat: fix data sections alignment
References: <E1LfGwO-0007Kq-6c@mailer.emlix.com>	<20090310073350.GH10393@linux-sh.org>	<20090402135343.d18d17a5.akpm@linux-foundation.org>	<20090409142553.GA3330@emlix.com>	<20090505140847.GB25409@emlix.com>	<20090527114955.GA23343@emlix.com>	<20090527134357.601c3c87.akpm@linux-foundation.org>	<20090528000801.GA30594@linux-sh.org> <20090527171631.ed4de515.akpm@linux-foundation.org>
In-Reply-To: <20090527171631.ed4de515.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 28 May 2009 09:08:02 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
>
>   
>> On Wed, May 27, 2009 at 01:43:57PM -0700, Andrew Morton wrote:
>>     
>>> On Wed, 27 May 2009 13:49:56 +0200
>>> Johannes Weiner <jw@emlix.com> wrote:
>>>       
>>>> On Tue, May 05, 2009 at 04:08:47PM +0200, Johannes Weiner wrote:
>>>>         
>>>>> On Thu, Apr 09, 2009 at 04:25:53PM +0200, Johannes Weiner wrote:
>>>>>           
>>>>>> On Thu, Apr 02, 2009 at 01:53:43PM -0700, Andrew Morton wrote:
>>>>>> Paul and Mike had complaints.  Paul acked the last revision.  Mike?
>>>>>> We need this for upstream to compile on our configuration.
>>>>>>             
>>> Who is Mike?
>>>
>>> (A pox upon email clients which strip real names)
>>>
>>>       
>>>>> Can we get this merged?  Nobody complained.
>>>>>           
>>>> <periodic echo-request>
>>>>
>>>> What are the plans on this now?  I assume it drowned in other changes...
>>>> Is it too late to get this in .30 now?
>>>>         
>>> The patch had a fairly shaky start and it's been unclear to me that
>>> everyone is happy with it and has tested it.
>>>
>>>  arch/arm/include/asm/flat.h      |    3 --
>>>  arch/blackfin/include/asm/flat.h |    1 
>>>  arch/h8300/include/asm/flat.h    |    1 
>>>  arch/m32r/include/asm/flat.h     |    1 
>>>  arch/m68k/include/asm/flat.h     |    1 
>>>  arch/sh/include/asm/flat.h       |    1 
>>>  fs/binfmt_flat.c                 |   46 ++++++++++++++++++++++++++-------------
>>>
>>> I guess ARM is the major architecture amongst that lot.  Have Russell
>>> and co had a decent look through this?
>>>
>>>       
>> The problem here is that the ARM nommu people seem to have disappeared
>> shortly after getting their changes merged. I see no activity within the
>> kernel for ARM nommu since 2006.
>>     
>
> heh, OK.  Oskar touched it last, so he's now ARM nommu maintainer.
>
>   
>> Given that xtensa has a need for this in
>> its nommu port and people are working on it presently, there certainly
>> has to be a limit to how far we go in allowing an outdated and
>> effectively abandoned port from blocking progress. Perhaps Russell has a
>> more optimistic outlook on the future of ARM nommu, though.
>>
>> The only architectures in that list presently active in the linux nommu
>> space in terms of development, support, and shipping products, are
>> blackfin, m68k, and sh. This too has been the case for years. Microblaze
>> has recently been added (which will also need the same change to its
>> flat.h), and it seems the xtensa folks are at least presently willing to
>> do more than the bare minimum to keep their port limping along.
>>     
>
> OK, thanks, I'll send it in to Linus this week.
>   
Can you remove flat_stack_align for Microblaze too? It should be in this
patch too.

Thanks,
Michal

diff --git a/arch/microblaze/include/asm/flat.h
b/arch/microblaze/include/asm/flat.h
index acf0da5..6847c15 100644
--- a/arch/microblaze/include/asm/flat.h
+++ b/arch/microblaze/include/asm/flat.h
@@ -13,7 +13,6 @@
 
 #include <asm/unaligned.h>
 
-#define        flat_stack_align(sp) /* nothing needed */
 #define        flat_argvp_envp_on_stack()      0
 #define        flat_old_ram_flag(flags)        (flags)
 #define        flat_reloc_valid(reloc, size)   ((reloc) <= (size))




> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

