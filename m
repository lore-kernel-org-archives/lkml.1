Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbYH0JjT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbYH0JjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:39:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYH0JjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:39:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:35274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbYH0JjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:39:08 -0400
Message-ID: <48B52068.2090502@kernel.org>
Date: Wed, 27 Aug 2008 11:37:44 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org, perex@perex.cz
Subject: Re: [PATCH RESEND] sound: make OSS sound core optional
References: <48B50E17.4020106@kernel.org> <s5hprnubz89.wl%tiwai@suse.de>
In-Reply-To: <s5hprnubz89.wl%tiwai@suse.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 27 Aug 2008 09:38:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Takashi Iwai wrote:
>> +config SOUND_OSS_CORE
>> +	bool
>> +	default n
>> +
>>  source "sound/oss/dmasound/Kconfig"
> 
> This seems missing from the scope.
> But, I think this should be rather in the block "if SOUND_PRIME" below.

SOUND_OSS_CORE should be turned on if ALSA OSS emul is turned on or
arch-um hostsound is turned on, both of which can be enabled regardless
of SOUND_PRIME, no?

>> --- work.orig/sound/sound_core.c
>> +++ work/sound/sound_core.c
> (snip)
>> +MODULE_ALIAS_CHARDEV_MAJOR(SOUND_MAJOR);
> 
> This alias should be in #ifdef CONFIG_SOUND_OSS_CORE.
> The module doesn't provide that major without CONFIG_SOUND_OSS_CORE.

Ah.. right.  Moving.

Thanks.

-- 
tejun
