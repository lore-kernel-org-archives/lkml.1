Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbXLLR5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbXLLR5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 12:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbXLLR5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 12:57:31 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36947 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751198AbXLLR5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 12:57:30 -0500
Date: Wed, 12 Dec 2007 18:57:31 +0100
From: Adrian Bunk <bunk@kernel.org>
To: mkrufky@linuxtv.org
Cc: mchehab@infradead.org, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-kbuild@vger.kernel.org
Subject: Re: [v4l-dvb-maintainer] build #340 failed for 2.6.24-rc5-g75b8c13
	in?linux/drivers/media/video/tuner.ko
Message-ID: <20071212175731.GD10069@stusta.de>
References: <1197470781.4744.41.camel@gaivota> <476005AE.7070401@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <476005AE.7070401@linuxtv.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 11:00:46AM -0500, mkrufky@linuxtv.org wrote:
> Mauro Carvalho Chehab wrote:
>...
> What we really need is to make the Kconfig selection behave as if it 
> depends on VIDEO_TUNER, but only if VIDEO_TUNER is selected.  I know 
> that sounds redundant, but that would actually solve the problem.
> 
> If VIDEO_TUNER is not selected, then the driver can be built as either Y 
> or M,  If, however, VIDEO_TUNER is selected, then the driver must be 
> built as whatever VIDEO_TUNER was selected as.
>...

The problem is not how to express this (which is not a big problem), the 
problem is how to keep these options maintainable...

I'll take a look at it (but I'm not sure whether this will be this year).
 
> remove the bit " if !VIDEO_TUNER_CUSTOMIZE" , such that the select lines 
> will read:
> 
>         select TUNER_MT20XX
>         select TUNER_TDA8290
>         select TUNER_TEA5761
>         select TUNER_TEA5767
>         select TUNER_SIMPLE
>         select TUNER_TDA9887
> 
> instead of:
> 
>         select TUNER_MT20XX if !VIDEO_TUNER_CUSTOMIZE
>         select TUNER_TDA8290 if !VIDEO_TUNER_CUSTOMIZE
>         select TUNER_TEA5761 if !VIDEO_TUNER_CUSTOMIZE
>         select TUNER_TEA5767 if !VIDEO_TUNER_CUSTOMIZE
>         select TUNER_SIMPLE if !VIDEO_TUNER_CUSTOMIZE
>         select TUNER_TDA9887 if !VIDEO_TUNER_CUSTOMIZE
> 
> If this fixes the problem, then I think it would be a good temporary fix 
> for 2.6.24, until we can make a better, more drastic fix for 2.6.25

select sets a minimum value for a variable, but our problem is that the 
value is too high...

> Thanks for testing.
> 
> Regards,
> Mike Krufky

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

