Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbZBKWob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbZBKWob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 17:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZBKWoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 17:44:23 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:59022 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZBKWoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 17:44:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z7QPe6yAFVVqZFBRbAiMtNgGnhulArd0UFsFsjjkEcmT2dl57cWfxgkvqbrYUK8por
         vugJX4nlRzts+c2DFIu2rdxjIAQZFOzkjVrqPmBSRXdJ8P2FITjVAJqKr5PeBnuqFZR1
         VD3QrD23nYpgupaiBM2Oo1/ln8R5m7ev4NVpQ=
MIME-Version: 1.0
In-Reply-To: <20090211143844.27ca0d6c.akpm@linux-foundation.org>
References: <49929EB8.4020802@tremplin-utc.net>
	 <1234346803-19811-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <20090211143844.27ca0d6c.akpm@linux-foundation.org>
Date: Wed, 11 Feb 2009 23:44:20 +0100
Message-ID: <cb7bb73a0902111444h46be9b65pa01d4b2b9c31afe8@mail.gmail.com>
Subject: Re: [PATCHv7] lis3lv02d: support both one- and two-byte sensors
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, eric.piel@tremplin-utc.net, pavel@suse.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 11:38 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 11 Feb 2009 11:06:43 +0100
> Giuseppe Bilotta <giuseppe.bilotta@gmail.com> wrote:
>
>> Sensors responding with 0x3B to WHO_AM_I only have one data register per
>> direction, thus returning a signed byte from the position which is
>> occupied by the MSB in sensors responding with 0x3A.
>>
>> Since multiple sensors share the reply to WHO_AM_I, we rename the
>> defines to better indicate what they identify (family of single and
>> double precision sensors).
>>
>> We support both kind of sensors by checking for the sensor type on init
>> and defining appropriate data-access routines and sensor limits (for the
>> joystick) depending on what we find.
>>
>
> Which tree is this patch against?
>
>> --- a/drivers/hwmon/lis3lv02d.c
>> +++ b/drivers/hwmon/lis3lv02d.c
>> @@ -53,9 +53,6 @@
>>   * joystick.
>>   */
>>
>> -/* Maximum value our axis may get for the input device (signed 12 bits) */
>> -#define MDPS_MAX_VAL 2048
>> -
>>  struct acpi_lis3lv02d adev = {
>>       .misc_wait   = __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
>>  };
>
> Current Linus mainline has
>
> struct acpi_lis3lv02d adev;
> EXPORT_SYMBOL_GPL(adev);
>
> here.

I based my patch on Linus' tree, plus Pavel's patch which I've been
told is on your tree.

Is your tree available for git? I can try basing it on yours directly.

> Also, this comment:
>
> /*
>  * The sensor can also generate interrupts (DRDY) but it's pretty pointless
>  * because their are generated even if the data do not change. So it's better
>  * to keep the interrupt for the free-fall event. The values are updated at
>  * 40Hz (at the lowest frequency), but as it can be pretty time consuming on
>  * some low processor, we poll the sensor only at 20Hz... enough for the
>  * joystick.
>  */
>
> seems to be describing something which isn't there.

I have no idea about that, I didn't touch it at all.

-- 
Giuseppe "Oblomov" Bilotta
