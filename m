Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXDRG0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXDRG0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 02:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXDRG0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 02:26:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:21838 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbXDRG0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 02:26:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=HlG0beMY3YR0LnHEk50oV2+UxyTFGPyknaDw77q5/KAQK0xLu54sfuTt1hPVMbxfTZN4f1eB6mwtcVRpuY9BXDacySCq5STfa9yb3f0cEnb+yOhLRZ0Yc4j8Xnst9Ier3SZU6dEgGTBDhMWoDXzMqi96gBzQ7tQSTk4gd/qz3DU=
Message-ID: <4625BA1A.9030808@gmail.com>
Date: Wed, 18 Apr 2007 15:26:34 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add Samsung HD401LJ to the NCQ blacklist
References: <20070418061541.GA11293@roonstrasse.net>
In-Reply-To: <20070418061541.GA11293@roonstrasse.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Max Kellermann wrote:
> Yet another hard drive which doesn't seem to get NCQ right.
> 
>  ata1: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl
>  0x1501000 status 0x400 next cpb count 0xB next cpb idx 0x0
>  [...]
>  ata1: timeout waiting for ADMA IDLE, stat=0x400
>  ata1: timeout waiting for ADMA LEGACY, stat=0x400
>  ata1.00: exception Emask 0x0 SAct 0x3fff SErr 0x200000 action 0x2
>  frozen
>  [...]
>  ata1: soft resetting port
> 
> http://lkml.org/lkml/2007/3/16/184
> 
> Signed-off-by: Max Kellermann <max@duempel.org>
> 
>  drivers/ata/libata-core.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 0abd72d..39a4c05 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3374,6 +3374,7 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "Maxtor 6L250S0",     "BANC1G10",     ATA_HORKAGE_NONCQ },
>  	/* NCQ hard hangs device under heavier load, needs hard power cycle */
>  	{ "Maxtor 6B250S0",	"BANC1B70",	ATA_HORKAGE_NONCQ },
> +        { "SAMSUNG HD401LJ",	NULL,		ATA_HORKAGE_NONCQ, },
>  	/* Blacklist entries taken from Silicon Image 3124/3132
>  	   Windows driver .inf file - also several Linux problem reports */
>  	{ "HTS541060G9SA00",    "MB3OC60D",     ATA_HORKAGE_NONCQ, },

Can you try it on another controller?  Say, a ahci or sil24?

-- 
tejun
