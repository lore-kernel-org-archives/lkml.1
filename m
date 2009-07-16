Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbZGPNWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbZGPNWf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 09:22:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755855AbZGPNWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 09:22:34 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:50911 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbZGPNWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 09:22:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J16FStnbJ5oP1jV8P2LwdHoRqaxTNFwHk5oZ+lN94tZEPpQXJ/C7vrQjAlXsAIk308
         7Tbt2yFJoOEG2/Zs9hbOKWguYg7ADvGANfWQSH1e+McGhBccDBuYwDoAvC22xyJpR/yS
         aIRvv2S2kw0boHkbk98dxWHpLlL0Cc9+rVnR4=
MIME-Version: 1.0
In-Reply-To: <20090711111110.6be67d82@linux-lm>
References: <1247098591-4887-1-git-send-email-tom.leiming@gmail.com>
	 <d82e647a0907081720v438344fcj1b37e0e226818632@mail.gmail.com>
	 <20090710173649.GB3687@kroah.com> <20090711111110.6be67d82@linux-lm>
Date: Thu, 16 Jul 2009 21:22:33 +0800
Message-ID: <d82e647a0907160622y2ec1798eue1310b7feaf79114@mail.gmail.com>
Subject: Re: [PATCH] driver core:firmware_class:fix memory leak of page 
	pointers array
From: Ming Lei <tom.leiming@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, catalin.marinas@arm.com, dwmw2@infradead.org,
       kay.sievers@vrfy.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/7/11 Ming Lei <tom.leiming@gmail.com>:
> On Fri, 10 Jul 2009 10:36:49 -0700
> Greg KH <greg@kroah.com> wrote:
>
>> On Thu, Jul 09, 2009 at 08:20:48AM +0800, Ming Lei wrote:
>> > 2009/7/9  <tom.leiming@gmail.com>:
>> > > From: Ming Lei <tom.leiming@gmail.com>
>> > >
>> > > The page pointers array is allocated in fw_realloc_buffer()
>> > > called by firmware_data_write(), and should be freed in release
>> > > function of firmware device.
>> > >
>> > > Signed-off-by:Ming Lei <tom.leiming@gmail.com>
>> > > Reported-by:Catalin Marinas <catalin.marinas@arm.com>
>> > > Acked-by: David Woodhouse <David.Woodhouse@intel.com>
>> >
>> > ---
>> > This patch is against Catalin Marinas's patch:
>> >     [PATCH] Free struct device in fw_dev_release()
>>
>> Hm, I never got a final version of that patch, care to send it to me?

Hi,Greg

Care to queue the patch into your driver-core tree and send it to -rc4?
Thanks.

>
> It is the latest version and now is against linus mainline.
> Thanks.
>
> From 50603673f5c68eb843584e65cc9930919910f98a Mon Sep 17 00:00:00 2001
> From: Ming Lei <tom.leiming@gmail.com>
> Date: Thu, 9 Jul 2009 07:56:52 +0800
> Subject: [PATCH] driver core:firmware_class:fix memory leak of page pointers array
>
> The page pointers array is allocated in fw_realloc_buffer() called by
> firmware_data_write(), and should be freed in release function of firmware
> device.
>
> Signed-off-by:Ming Lei <tom.leiming@gmail.com>
> Reported-by:Catalin Marinas <catalin.marinas@arm.com>
> Acked-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
>  drivers/base/firmware_class.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index fc46653..2643366 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -180,7 +180,6 @@ static ssize_t firmware_loading_store(struct device *dev,
>                                goto err;
>                        }
>                        /* Pages will be freed by vfree() */
> -                       fw_priv->pages = NULL;
>                        fw_priv->page_array_size = 0;
>                        fw_priv->nr_pages = 0;
>                        complete(&fw_priv->completion);
> --
> 1.6.0.GIT
>
>
>
>
>
> --
> Lei Ming
>



-- 
Lei Ming
