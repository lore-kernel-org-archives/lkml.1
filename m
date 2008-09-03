Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbYICIfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbYICIfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 04:35:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYICIff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 04:35:35 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:50045 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYICIfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 04:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=V8R9I8bU+lciDE7xsaMFVASjhwSOu5Ku/14Aaom+59Ow7x1VQjSQvGk5Ru7PT2NUzQ
         7ETKl1gAZHdKLJ8lUqGC+SsmIFgdJeECwhKysBZvURVOK7TsMsjIODDRh62JGHhMUxZF
         T+1cu4JWh5/CI/1k3wezrn/LPGucqW8dWLt6U=
Message-ID: <386072610809030135y7d8762dg713897101b3242bd@mail.gmail.com>
Date: Wed, 3 Sep 2008 16:35:32 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] ALSA: add dummy function to support shared mmap in nommu Blackfin arch (v2)
Cc: tiwai@suse.de, alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       "Cliff Cai" <cliff.cai@analog.com>
In-Reply-To: <8bd0f97a0809020637n2c7e29bexe87bd3dca50cee88@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220349522-17995-1-git-send-email-cooloney@kernel.org>
	 <8bd0f97a0809020637n2c7e29bexe87bd3dca50cee88@mail.gmail.com>
X-Google-Sender-Auth: 88fcaa8ddabbee10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2008 at 9:37 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Tue, Sep 2, 2008 at 5:58 AM, Bryan Wu wrote:
>> From: Cliff Cai <cliff.cai@analog.com>
>>
>> v1-v2:
>>  - only adding this dummy function in nommu arch
>>
>> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>> ---
>>  sound/core/pcm_native.c |   14 ++++++++++++++
>>  1 files changed, 14 insertions(+), 0 deletions(-)
>>
>> diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
>> index c49b9d9..1e88cde 100644
>> --- a/sound/core/pcm_native.c
>> +++ b/sound/core/pcm_native.c
>> @@ -3391,6 +3391,14 @@ out:
>>  }
>>  #endif /* CONFIG_SND_SUPPORT_OLD_API */
>>
>> +#ifndef CONFIG_MMU
>> +unsigned long dummy_get_unmapped_area(struct file *file, unsigned long addr,
>> +                                     unsigned long len, unsigned long pgoff, unsigned long flags)
>> +{
>> +       return 0;
>> +}
>> +#endif
>
> if you had:
> #else
> # define dummy_get_unmapped_area NULL
> #endif
> then you could avoid #ifdef in the rest of the file ...
> -mike
>

Right, I will refresh this patch.

-Bryan
