Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbYBFMiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbYBFMiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761196AbYBFMiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:38:46 -0500
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:34711 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758132AbYBFMip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:38:45 -0500
Message-ID: <47A9AA4F.80508@tiscali.nl>
Date: Wed, 06 Feb 2008 13:38:39 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Kristoffer Ericson <kristoffer.ericson@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, rpurdie@openedhand.com,
       Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/HP7XX] - Add combined LCD / BL driver for platform HP
 Jornada 7xx handhelds
References: <20080205195331.fa2ca02b.Kristoffer.ericson@gmail.com> <47A9A944.7090401@tiscali.nl>
In-Reply-To: <47A9A944.7090401@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin wrote:
> Kristoffer Ericson wrote:
>> Greetings,
>>
>> Richard I've cleaned up the driver by checking with checkpatch.pl as Russell suggested. I would appreciate it if you could
>> look through the patch again and give comments since the patch looks somewhat different.
>>
>> I can add patch for Kconfig/Makefile later on but suspect there will be some changes required before that.
>>
>> Oh and to answer your question regarding MAX/MIN values of the backlight, 0 = max and 255 = min. So we simply turn it around
>> by returning 255 - value. Same thing when we need to set value.
>>
>> Best wishes
>> Kristoffer Ericson
>>
>> diff --git a/drivers/video/backlight/jornada720_bllcd.c b/drivers/video/backlight/jornada720_bllcd.c

>> +static int jornada_bl_get_brightness(struct backlight_device *dev)
>> +{
>> +	int ret;
>> +
>> +	/* check if backlight is on */
>> +	if (!(PPSR & PPC_LDD1))
>> +		return 255;
> return JORNADA_BL_MAX_BRIGHTNESS;
> 
>> +
>> +	jornada_ssp_start();
>> +	if (jornada_ssp_inout(GETBRIGHTNESS) == -ETIMEDOUT) {
>> +		printk(KERN_ERR "jornada720_bl: GetBrightness failed\n");
>> +		ret = 256;
> ret = JORNADA_BL_MAX_BRIGHTNESS + 1;
>> +	} else
>> +		ret = jornada_ssp_inout(TXDUMMY);

forgot to mention missing curly bracket here

>> +
>> +	jornada_ssp_end();
>> +
>> +	/* 0 is max brightness */
>> +	return (255 - ret);
> return (JORNADA_BL_MAX_BRIGHTNESS - ret);
>> +}
