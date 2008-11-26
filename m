Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYKZIMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYKZIMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbYKZIMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:12:10 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:56728 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYKZIMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:12:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ABOS1ZohMWBl3nrMBbcbdaa7yBBbVoLmoABZtYpNUbTe61NKrn1C27AfgkkpIBFnl7
         e2uSrcF8nXFoY9EBDgvWnMcnkf+jaTdFzHZ+7YNZa6J9tkiwUG2t2Gyt8G2fv+xken8F
         msEYjcFf9zU1GQpY21oZt/4vtpKmpbIVq5WJ8=
Message-ID: <f17812d70811260012n57e89eb9q1101fa1e13813a49@mail.gmail.com>
Date: Wed, 26 Nov 2008 16:12:07 +0800
From: "Eric Miao" <eric.y.miao@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
Cc: "Mike Rapoport" <mike@compulab.co.il>, "Eric Miao" <ymiao3@marvell.com>,
       rpurdie@rpsys.net, linux-kernel@vger.kernel.org
In-Reply-To: <492BCD01.7080508@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1227606164-12659-1-git-send-email-mike@compulab.co.il>
	 <E913911567467945BBEB9277E27868B00153DC31@msiexch01.marvell.com>
	 <492BCD01.7080508@compulab.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

Do you have any suggestion to this?

On Tue, Nov 25, 2008 at 6:01 PM, Mike Rapoport <mike@compulab.co.il> wrote:
>
>
> Eric Miao wrote:
>> Isn't modprobe supposed to be smart enough for things like this?
>
> Here's snap from build log:
>
> mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $ touch drivers/video/backlight/da903x.c
> mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $ touch drivers/regulator/da903x.c
> mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $ make O=/home/mike/arm/kernel/build/pxa/  modules
>  CHK     include/linux/version.h
> make[2]: `include/asm-arm/mach-types.h' is up to date.
>  Using /mnt/sdb1/git/linux-2.6-arm as source for kernel
>  GEN     /home/mike/arm/kernel/build/pxa/Makefile
>  CHK     include/linux/utsrelease.h
>  SYMLINK include/asm -> include/asm-arm
>  CALL    /mnt/sdb1/git/linux-2.6-arm/scripts/checksyscalls.sh
> <stdin>:1097:2: warning: #warning syscall fadvise64 not implemented
> <stdin>:1265:2: warning: #warning syscall migrate_pages not implemented
> <stdin>:1321:2: warning: #warning syscall pselect6 not implemented
> <stdin>:1325:2: warning: #warning syscall ppoll not implemented
> <stdin>:1365:2: warning: #warning syscall epoll_pwait not implemented
>  CC [M]  drivers/regulator/da903x.o
>  CC [M]  drivers/video/backlight/da903x.o
>  Building modules, stage 2.
>  MODPOST 70 modules
>  LD [M]  drivers/video/backlight/da903x.ko
> mike@gentoodev /mnt/sdb1/git/linux-2.6-arm $
>
> So, apparently modpost is not smart enough for things like this :)
>
>> I'm afraid if modprobe isn't so capable, we may encounter the same
>> issue with other drivers and sometimes it is not so easy for
>> developers of aphasia like me to choose a better name :)
>>
>> - eric
>>
>> -----Original Message-----
>> From: Mike Rapoport [mailto:mike@compulab.co.il]
>> Sent: Tuesday, November 25, 2008 5:43 PM
>> To: rpurdie@rpsys.net
>> Cc: Eric Miao; linux-kernel@vger.kernel.org; Mike Rapoport
>> Subject: [PATCH] drivers/video/backlight: rename da903x to da903x_bl
>>
>> Currently both da903x backlight and voltage reulator drivers have the
>> same name. Rename the backlight driver to allow use of both drivers as
>> modules.
>>
>> Signed-off-by: Mike Rapoport <mike@compulab.co.il>
>> ---
>>  drivers/video/backlight/Makefile                  |    2 +-
>>  drivers/video/backlight/{da903x.c => da903x_bl.c} |    0
>>  2 files changed, 1 insertions(+), 1 deletions(-)
>>  rename drivers/video/backlight/{da903x.c => da903x_bl.c} (100%)
>>
>> diff --git a/drivers/video/backlight/Makefile
>> b/drivers/video/backlight/Makefile
>> index 103427d..2d8f7cb 100644
>> --- a/drivers/video/backlight/Makefile
>> +++ b/drivers/video/backlight/Makefile
>> @@ -18,7 +18,7 @@ obj-$(CONFIG_BACKLIGHT_OMAP1)       += omap1_bl.o
>>  obj-$(CONFIG_BACKLIGHT_PROGEAR) += progear_bl.o
>>  obj-$(CONFIG_BACKLIGHT_CARILLO_RANCH) += cr_bllcd.o
>>  obj-$(CONFIG_BACKLIGHT_PWM)  += pwm_bl.o
>> -obj-$(CONFIG_BACKLIGHT_DA903X)       += da903x.o
>> +obj-$(CONFIG_BACKLIGHT_DA903X)       += da903x_bl.o
>>  obj-$(CONFIG_BACKLIGHT_MBP_NVIDIA) += mbp_nvidia_bl.o
>>  obj-$(CONFIG_BACKLIGHT_TOSA) += tosa_bl.o
>>  obj-$(CONFIG_BACKLIGHT_SAHARA)       += kb3886_bl.o
>> diff --git a/drivers/video/backlight/da903x.c
>> b/drivers/video/backlight/da903x_bl.c
>> similarity index 100%
>> rename from drivers/video/backlight/da903x.c
>> rename to drivers/video/backlight/da903x_bl.c
>
> --
> Sincerely yours,
> Mike.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Cheers
- eric
