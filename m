Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbZBISJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbZBISJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 13:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753528AbZBISIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 13:08:52 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:54141 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbZBISIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 13:08:51 -0500
Message-ID: <4990712F.8000802@numericable.fr>
Date: Mon, 09 Feb 2009 19:08:47 +0100
From: etienne <etienne.basset@numericable.fr>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, Dave Airlie <airlied@redhat.com>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: [Bug #12613] [Suspend regression][DRM, RADEON]
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>	 <sWhNs83kKPE.A.HiF.r20jJB@chimera> <498F5785.3000009@numericable.fr> <21d7e9970902081826r48777cb8s8c4e882a02575c71@mail.gmail.com>
In-Reply-To: <21d7e9970902081826r48777cb8s8c4e882a02575c71@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Mon, Feb 9, 2009 at 8:07 AM, etienne <etienne.basset@numericable.fr> wrote:
>   
>> Rafael J. Wysocki wrote:
>>     
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.28.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12613
>>> Subject         : [Suspend regression][DRM, RADEON]
>>> Submitter       : etienne <etienne.basset@numericable.fr>
>>> Date            : 2009-01-28 22:00 (12 days old)
>>> First-Bad-Commit:
>>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=a9d51a5ad1154b5b20add1e8d30a5564f8aabbe9
>>> References      : http://marc.info/?l=linux-kernel&m=123318030419558&w=4
>>>                  http://marc.info/?l=linux-kernel&m=123334865404574&w=4
>>>
>>>
>>>
>>>       
>> hello,
>> yes it's still present in -rc4
>> But I noticed that when I switch off KDE4.2 desktop effects, suspend to ram
>> is 100% reliable with 2.6.29-rc4
>> With 2.6.28, STR is 100% reliable with or without desktop effects
>>
>>     
>
> Hi Etienne,
>
> Can you try commenting out the calls to the radeon_suspend and
> radeon_resume hooks in radeon_drv.c?
>
> Dave.
>   
Hi Dave,

I just tested that and I didn't change anything (cannot STR/resume with 
desktop effect, STR/resume OK without desktop effects)

thanks,
Etienne

the patch i used, to verify i understood you ;)

diff --git a/drivers/gpu/drm/radeon/radeon_drv.c 
b/drivers/gpu/drm/radeon/radeon
index fef2078..805b367 100644
--- a/drivers/gpu/drm/radeon/radeon_drv.c
+++ b/drivers/gpu/drm/radeon/radeon_drv.c
@@ -90,8 +90,8 @@ static struct drm_driver driver = {
        .postclose = radeon_driver_postclose,
        .lastclose = radeon_driver_lastclose,
        .unload = radeon_driver_unload,
-       .suspend = radeon_suspend,
-       .resume = radeon_resume,
+/*     .suspend = radeon_suspend,
+       .resume = radeon_resume, */
        .get_vblank_counter = radeon_get_vblank_counter,
        .enable_vblank = radeon_enable_vblank,
        .disable_vblank = radeon_disable_vblank,


