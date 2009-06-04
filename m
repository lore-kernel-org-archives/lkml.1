Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbZFDIQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbZFDIQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZFDIQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:16:14 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:8794 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZFDIQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:16:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vOvW9Kj+auWMWXNbIKuLY6/J4N4RzxXk0Gvs5Qhc2XTHKiuLlBanvMdjX48NaE8Wx8
         dvOfP4m9alfONkp77x7FtIF9K0ooxv1Lsz1RkqTDPMQOa+/5suG7/x11oT2whRddq/3m
         3dQfkdVOqdS9Dv7Nqv8y2LDrRimY/WUTLRmOw=
MIME-Version: 1.0
In-Reply-To: <20090604005435.d3671419.akpm@linux-foundation.org>
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org>
	 <20090604005435.d3671419.akpm@linux-foundation.org>
Date: Thu, 4 Jun 2009 04:16:14 -0400
Message-ID: <8bd0f97a0906040116v659d0cdetaff267f4241be175@mail.gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 03:54, Andrew Morton wrote:
> On Wed,  3 Jun 2009 04:16:59 -0400 Mike Frysinger wrote:
>> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>
> -ENOCHANGELOGAGAIN

it's pretty damned self explanatory

>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 51a8d41..7f79732 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -274,7 +274,12 @@ static ssize_t gpio_value_store(struct device *dev,
>>       else {
>>               long            value;
>>
>> -             status = strict_strtol(buf, 0, &value);
>> +             if (sysfs_streq(buf, "toggle")) {
>> +                     value = !gpio_get_value_cansleep(gpio);
>> +                     status = 0;
>> +             } else
>> +                     status = strict_strtol(buf, 0, &value);
>> +
>>               if (status == 0) {
>>                       gpio_set_value_cansleep(gpio, value != 0);
>>                       status = size;
>
> A suitable place to document this is Documentation/gpio.txt.

yes, but i wanted to make sure David didnt reject the idea before i
spend time writing documentation.
-mike
