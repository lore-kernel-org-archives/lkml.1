Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZBZHF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZBZHF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbZBZHFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:05:49 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:32262 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZBZHFs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lNFSpv/4SWkpM+lU6i0+CcvzeLAnrWRp43UrRTgofVX2VgvaRuwpBcz3iKRNvHBqhP
         UjnfMxcDfGSR2hMZmYgbcRSvX2fgFrY3DDeGxsoaGf9YEh3R41p9wSJIw3q2MN5QZooY
         6KQpOuy9YqaJkXWYWg2K5d0JxKwmzBX0CAoc4=
MIME-Version: 1.0
In-Reply-To: <20090225093440.GA5414@july>
References: <20090225093440.GA5414@july>
Date: Thu, 26 Feb 2009 12:35:45 +0530
Message-ID: <5d5443650902252305h6e221b4epd724d8331607eebb@mail.gmail.com>
Subject: Re: [PATCH] LED key trigger support
From: Trilok Soni <soni.trilok@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, rpurdie@rpsys.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

> +
> +static int key_notifier_callback(struct notifier_block *nb,
> +                               unsigned long event, void *data)
> +{
> +       struct key_trigger_notifier *kn = container_of(nb,
> +                                       struct key_trigger_notifier, notifier);
> +       struct led_classdev *led = kn->led;
> +       unsigned int *key_value = (unsigned int *) data;

No need of casting from void *.

> +
> +       /* In case of touchscreen, just skip it */
> +       if (*key_value == BTN_TOUCH)
> +               return 0;

I think this filtering is already done by notification patch.

> +
> +       led_set_brightness(led, event);
> +       return 0;
> +
> +}
> +
> +static void key_led_activate(struct led_classdev *led)
> +{
> +       struct key_trigger_notifier *kn;
> +       int ret;
> +
> +       kn = kzalloc(sizeof(struct key_trigger_notifier), GFP_KERNEL);
> +       if (!kn) {
> +               dev_err(led->dev, "unable to allocatate key trigger\n");

s/allocatate/allocate

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
