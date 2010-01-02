Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897Ab0ABXEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab0ABXEO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212Ab0ABXEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:04:13 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55453 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0ABXEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:04:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=mx+grVxXp5VKHnlKcAYykdmNpYZCWN50F5U1BmowTCK/yZu6s3iJ1pWeo2ppeFuo/l
         Sf4L1fBY2reKXaBlRiA59AUYg12qq/3FfSHvpK5ZkB+TtiTdE9D2lMNYwd8XNMSgJJAT
         /e5Xi5j4eXeeHbr1F022sd7LLp0z7IsuAp708=
Message-ID: <4B3FD0E8.1010507@gmail.com>
Date: Sat, 02 Jan 2010 17:04:08 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Nizette <bn@niasdigital.com>
CC: Pierre Ossman <pierre@ossman.eu>, Hein_Tibosch <hein_tibosch@yahoo.es>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v3] mmc: Make ID freq configurable
References: <1246492196.2980.17.camel@linux-51e8.site> <20090702135849.21370282@hskinnemoen-d830> <1246537056.2980.60.camel@linux-51e8.site> <4B3E570C.2060602@yahoo.es> <63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com> <4B3F019F.6010306@yahoo.es> <49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com> <20100102130809.121b7e10@mjolnir.ossman.eu> <AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com>
In-Reply-To: <AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2010 04:23 PM, Ben Nizette wrote:
>
> On 02/01/2010, at 11:08 PM, Pierre Ossman wrote:
>
>> On Sat, 2 Jan 2010 20:07:01 +1100
>> Ben Nizette<bn@niasdigital.com>  wrote:
>>
>>>
>>> Pierre, thoughts?  All my cards were borderline spec but Hein's got a mainstream, common card which seems to completely ignore the spec.  Can we just take the few-hundred-uS hit and allow initialization down at the bottom end, say 100kHz?
>>>
>>
>> Broken cards seem to be all over the spectrum, so I wouldn't be
>> suprised if you find ones that break if you go too low as well.
>
> Yea good point, though given there might not even be a One Freq to Rule Them All, how about:
>
> ---8<---
>
> From: Ben Nizette<bn@niasdigital.com>
> Subject: [PATCH v3] mmc: Make ID freq configurable
>
> While the SD spec specifies a range of frequencies for the ID phase from 100-400kHz, not all cards play by the rules.  This patch adds a Kconfig option to allow the user to tweak this to their card/host config, though the default of 250kHz should be fine for all spec-abiding cards and most others besides.
>
> Signed-off-by: Ben Nizette<bn@niasdigital.com>
>
> ---
> diff --git a/drivers/mmc/core/Kconfig b/drivers/mmc/core/Kconfig
> index ab37a6d..a8e5003 100644
> --- a/drivers/mmc/core/Kconfig
> +++ b/drivers/mmc/core/Kconfig
> @@ -14,3 +14,15 @@ config MMC_UNSAFE_RESUME
>            This option is usually just for embedded systems which use
>            a MMC/SD card for rootfs. Most people should say N here.
>
> +config MMC_ID_FREQ
> +       int "SD/MMC Card initialisation frequency (Hz)"
> +       default 250000
> +       help
> +         The SD card specification allows for initialisation
> +         frequencies from 100-400kHz however some broken cards are
> +         known not to work across this whole range.
> +
> +         If you're having problems with a particular card not being
> +         detected, you may try adjusting this frequency up or down
> +         but for widest compatibility just leave it default.

Don't know that a kconfig option is best for this, it'd suck to have to 
recompile the kernel to change it. Module option might be better..
