Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZEYXOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZEYXOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 19:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbZEYXN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 19:13:57 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:59174 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151AbZEYXN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 19:13:57 -0400
From: Frans Pop <elendil@planet.nl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [PATCH 2/3] ide: preserve HPA by default
Date: Tue, 26 May 2009 01:10:08 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
References: <200905252344.57797.bzolnier@gmail.com>
In-reply-To: <200905252344.57797.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905260110.09496.elendil@planet.nl>
X-OriginalArrivalTime: 25 May 2009 23:10:09.0970 (UTC) FILETIME=[F35AA120:01C9DD8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> --- a/drivers/ide/Kconfig
> +++ b/drivers/ide/Kconfig
> @@ -91,6 +91,28 @@ config BLK_DEV_IDE_SATA
[...]
> +config IDE_PRESERVE_HPA
> +       bool "Preserve Host Protected Area (please read help)"
> +       default y
> +       help
> +         From the majority of modern users perspectives ignoring the HPA
> +         breaks vendor RAID formats, GPT partitions or risks corrupting
> +         firmware.

First sentence would IMO read better as:
"From the perspective of most users of recent systems, ignoring the
 HPA can break ..."

Maybe add "risks overwriting vendor system recovery tools"?

> +         Unfortunately the original (kernel versions < 2.6.30) behavior
> +         (ignoring HPA, using full disk capacity) was introduced at the
> +         time when the main HPA use was with the jumper (or software)
> +         to make the drive look small enough for the BIOS to allow boot
> +         with big drives.

"... the main use of HPA was to make the drive look small enough for the
 BIOS to allow the system to boot with large capacity drives."

I've dropped the "with the jumper (or software)" as it's confusing and
IMHO does not really add anything for the user (but see suggestion below).

> +         To allow the maximum compatibility with the existing setups
> +         (using HPA and partitioned with HPA disabled) the default HPA
> +         behavior can be also later adjusted using "ignore_hpa" module
> +         parameter (i.e. "ide_core.ignore_hpa=1").

"... can also be adjusted later using the "ignore_hpa" ..."

Maybe add a para here that explains what "Preserve Host Protected Area"
actually does, something like:
"If you say Y, the driver will respect the Host Protected Area if one is
 defined in the BIOS or (for older drives) through a jumper setting on
 the drive."

> +         Say Y unless you have such setup and for some reason cannot
> +         use "ignore_hpa" module parameter.

"... use the "ignore_hpa" module parameter."

Cheers,
FJP
