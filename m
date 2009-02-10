Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbZBJXqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbZBJXqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 18:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZBJXqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 18:46:39 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:22252 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbZBJXqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 18:46:39 -0500
X-Spam-Flag: NO
X-Spam-Score: -12.589
Message-ID: <499211D0.3090705@tremplin-utc.net>
Date: Wed, 11 Feb 2009 00:46:24 +0100
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20081231 Mandriva/2.0.0.19-1mdv2009.1 (2009.1) Thunderbird/2.0.0.19 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
Cc: git@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] lis3lv02d: support both one- and two-byte sensors
References: <1234309249-13672-1-git-send-email-giuseppe.bilotta@gmail.com>
In-Reply-To: <1234309249-13672-1-git-send-email-giuseppe.bilotta@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giuseppe Bilotta schreef:
> Sensors responding with 0x3B to WHO_AM_I only have one data register per
> direction, thus returning a signed byte from the position which is
> occupied by the MSB in sensors responding with 0x3A.
> 
> We support both kind of sensors by checking for the sensor type on init
> and defining appropriate data-access routines and sensor limits (for the
> joystick) depending on what we find.
> 
> Signed-off-by: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
> ---
> 
> This is the other version of the patch, and it changes access to use the
> base address from the 8-bit, so the 16-bit routine is changed to access
> the PREVIOUS byte for the LSB.
> 
> Choose whichever of the patches is deemed more correct 8-)
> 
> Note that both patches are based off Linus tree, so I don't know how
> they cope with Pavel's "don't touch too much on init" one. I'll try to
> work out a patch on top of that too.
Yes, great, and this one looks even better than v1 :-)
However I'm not sure about the conversion between s8 and s16:

> +static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
> +{
> +	u8 lo;
> +	adev.read(handle, reg, &lo);
> +	return *((s8*)(&lo));
> +}
Does it really extend the sign to 16 bits? I would have written it this way:
+static s16 lis3lv02d_read_8(acpi_handle handle, int reg)
+{
+	s8 lo;
+	adev.read(handle, reg, &lo);
+	return (s16)lo;
+}
Doesn't it work better?

Eric
