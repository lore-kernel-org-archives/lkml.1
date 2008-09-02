Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYIBJ7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYIBJ7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 05:59:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYIBJ7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 05:59:43 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:38362 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbYIBJ7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 05:59:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vrwSaRYppIOHYkGD3WVLSPX/U2xvkQfmdyDbPuYj8OnvCu4jMy9iUOpcJfrRLfuC7u
         GSAPh8WDroE1th2NLyRv31bawZFCfgS70UEmhiabCwEjwVC9DrvWfx+jkJGzhTQUJgIZ
         tK8UHBQGF13bZ1tCCBrEEcEil46ZyM1pax8Co=
Message-ID: <386072610809020259hd61d8barec55e453579ade1a@mail.gmail.com>
Date: Tue, 2 Sep 2008 17:59:40 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Takashi Iwai" <tiwai@suse.de>
Subject: Re: [PATCH 4/4] ALSA: add dummy function to support shared mmap in nommu Blackfin arch
Cc: "Cai, Cliff" <Cliff.Cai@analog.com>, perex@perex.cz,
       liam.girdwood@wolfsonmicro.com, broonie@opensource.wolfsonmicro.com,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
In-Reply-To: <s5hmyiqkhpr.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1219829968-6431-1-git-send-email-cooloney@kernel.org>
	 <1219829968-6431-5-git-send-email-cooloney@kernel.org>
	 <s5h4p559umn.wl%tiwai@suse.de>
	 <0F1B54C89D5F954D8535DB252AF412FA029D5EC2@chinexm1.ad.analog.com>
	 <s5hmyiqkhpr.wl%tiwai@suse.de>
X-Google-Sender-Auth: 17221dc782e71b78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 5:41 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 2 Sep 2008 11:16:37 +0800,
> Cai, Cliff wrote:
>>
>>
>> > @@ -3419,5 +3426,6 @@ const struct file_operations snd_pcm_f_ops[2] =
>> {
>> >             .compat_ioctl =         snd_pcm_ioctl_compat,
>> >             .mmap =                 snd_pcm_mmap,
>> >             .fasync =               snd_pcm_fasync,
>> > +           .get_unmapped_area =    dummy_get_unmapped_area,
>> >     }
>> >  };
>>
>> >I don't think adding this dummy get_unmapped_area unconditionally for
>> every driver is good.  This overrides the default
>> >mm->get_unmaped_area.
>> But without this dummy function,shared mmap on nommu arch would
>> fail,refer to validate_mmap_request() in mm/nommu.c.
>
> Yes, I know it's needed for nommu.  That's why I wrote
> "unconditionally" in the above.
>
>> May be we can add a kernel config item to include or not include this
>> function depending on non-mmu or mmu arch.
>
> Checking CONFIG_MMU may suffice?
>

Right, I post a v2 patch including this checking.

Thanks
-Bryan
