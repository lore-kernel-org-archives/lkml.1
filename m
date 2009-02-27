Return-Path: <linux-kernel-owner+w=401wt.eu-S1755950AbZB0CNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950AbZB0CNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 21:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754172AbZB0CNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 21:13:08 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:40396 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbZB0CNF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 21:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=O7G6y0o648wIjegJYzKuwqeehSd4DUP7DRfMEvLW+vVi+qoOH2bqloymV+l0m1AEDK
         KoJXbS533hAC+w7RET5L7naCLkMtw9CbzrYAx4RVfmmMg6ashbDabGUIazVH8dKmi23b
         m6wwAdgu6SRleeFpQuJDOlCK4Nv9uzdFKBHVM=
MIME-Version: 1.0
In-Reply-To: <5d5443650902252305h6e221b4epd724d8331607eebb@mail.gmail.com>
References: <20090225093440.GA5414@july>
	 <5d5443650902252305h6e221b4epd724d8331607eebb@mail.gmail.com>
Date: Fri, 27 Feb 2009 11:13:02 +0900
X-Google-Sender-Auth: dff67cc944aa2abc
Message-ID: <9c9fda240902261813s70189795hd7fe7c79151d6f87@mail.gmail.com>
Subject: Re: [PATCH] LED key trigger support
From: Kyungmin Park <kmpark@infradead.org>
To: Trilok Soni <soni.trilok@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, rpurdie@rpsys.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 4:05 PM, Trilok Soni <soni.trilok@gmail.com> wrote:
> Hi Kyungmin,
>
>> +
>> +static int key_notifier_callback(struct notifier_block *nb,
>> +                               unsigned long event, void *data)
>> +{
>> +       struct key_trigger_notifier *kn = container_of(nb,
>> +                                       struct key_trigger_notifier, notifier);
>> +       struct led_classdev *led = kn->led;
>> +       unsigned int *key_value = (unsigned int *) data;
>
> No need of casting from void *.
>
>> +
>> +       /* In case of touchscreen, just skip it */
>> +       if (*key_value == BTN_TOUCH)
>> +               return 0;
>
> I think this filtering is already done by notification patch.

No, touchscreen also use input_report_key function so it passed BTN_TOUCH value.
I don't want to key led blink at touchscreen.
>
>> +
>> +       led_set_brightness(led, event);
>> +       return 0;
>> +
>> +}
>> +
>> +static void key_led_activate(struct led_classdev *led)
>> +{
>> +       struct key_trigger_notifier *kn;
>> +       int ret;
>> +
>> +       kn = kzalloc(sizeof(struct key_trigger_notifier), GFP_KERNEL);
>> +       if (!kn) {
>> +               dev_err(led->dev, "unable to allocatate key trigger\n");
>
> s/allocatate/allocate

Sorry for typo, I will fix it.

Thank you,
Kyungmin Park
