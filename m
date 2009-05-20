Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbZETUCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbZETUCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 16:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZETUB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 16:01:59 -0400
Received: from ottmail.xandros.com ([142.46.212.35]:51712 "EHLO
	ottmail.xandros.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbZETUB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 16:01:58 -0400
X-Greylist: delayed 796 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 May 2009 16:01:58 EDT
Date: Wed, 20 May 2009 15:30:57 -0400
From: Woody Suwalski <woodys@xandros.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Zorael <zorael@gmail.com>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <4A145A71.20006@xandros.com>
In-Reply-To: <200905182159.12575.rjw@sisk.pl>
References: <fcd863fc0905181109h372e5967t9d179b820a62132d@mail.gmail.com>
References: <200905182101.06511.rjw@sisk.pl>
References: <20090518121140.d0bacafd.randy.dunlap@oracle.com>
References: <200905182159.12575.rjw@sisk.pl>
Subject: Re: [i915] Kernel does not compile when set to use i915 kernel mode-setting per default (CONFIG_DRM_I915_KMS=y)
x-scalix-Hops: 1
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII";
	format="flowed"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Monday 18 May 2009, Randy Dunlap wrote:
>   
>> On Mon, 18 May 2009 21:01:06 +0200 Rafael J. Wysocki wrote:
>>
>>     
>>> Adding CCs.
>>>
>>> On Monday 18 May 2009, you wrote:
>>>       
>>>> (First post, so please CC to zorael@gmail.com in case it doesn't automatically.)
>>>>
>>>>
>>>> I'm trying to compile 2.6.30-rc6 to enable kernel mode-setting *per
>>>> default*, for my Intel 945GME video chipset. Alas, when compiling, it
>>>> halts with the following tidbit:
>>>>
>>>> ...
>>>>   LD      .tmp_vmlinux1
>>>> drivers/built-in.o: In function `intel_opregion_free':
>>>> /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:422: undefined
>>>> reference to `acpi_video_exit'
>>>> drivers/built-in.o: In function `intel_opregion_init':
>>>> /usr/src/linux/drivers/gpu/drm/i915/i915_opregion.c:393: undefined
>>>> reference to `acpi_video_register'
>>>> make[1]: *** [.tmp_vmlinux1] Error 1
>>>> make[1]: Leaving directory `/usr/src/linux-2.6.29'
>>>> make: *** [debian/stamp/build/kernel] Error 2
>>>>
>>>>
>>>> grepping acpi_video_register recursively I see it's defined as an
>>>> empty function in ./include/acpi/video.h, and as a more proper
>>>> function in ./drivers/acpi/video.c. Does somehow setting it to use KMS
>>>> per default via CONFIG_DRM_I915_KMS=y stop it from reading those
>>>> files?
>>>>
>>>> I used to run with KMS by default in the early -30rc*s, but at some
>>>> point (rc2?), it stopped compiling succesfully. If I don't enable it
>>>> per default, it *does* compile, though I don't know how to explicitly
>>>> enable it at boot-time. So I'm living without KMS for the time being.
>>>> Woe.
>>>>
>>>> Anything obvious I'm doing wrong?
>>>>         
>> Len posted a patch for this.  It's below.
>> Len, do you have this patch queued for Linus?
>>     
>
> Ah, it's commit ecb4aed78dcf09e48c8c34c8c2fa7f5c69344be6, which went in
> slightly after -rc6.  So it should be fixed.
>
> Zorael, please test the current Linus' tree.
>
>   
Len's patch idea does not work for me - if ACPI is build as a module, I 
have no way to force acpi-video to be built in.
And kernel with i915 built-in breaks...
So to summarize: acpi=m with i915=y is broken...

For now I am simply commenting-out the i915 acpi-video calls, but that 
is not a good way...
We need to move the core acpi-video to the main kernel...

Thanks, Woody

-- 
Woody Suwalski, Xandros, Ottawa, Canada, 1-613-842-3498 x414

