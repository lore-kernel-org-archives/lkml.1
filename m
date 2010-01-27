Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954Ab0A0Gad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab0A0Gad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 01:30:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614Ab0A0Gac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 01:30:32 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45347 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab0A0Gac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 01:30:32 -0500
Message-ID: <4B5FDD85.5080701@cs.helsinki.fi>
Date: Wed, 27 Jan 2010 08:30:29 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christian Casteyde <casteyde.christian@free.fr>,
       vegard.nossum@gmail.com
Subject: Re: [PATCH] kmemleak: Do not enable KMEMCHECK_PARTIAL_OK if DEBUG_KMEMLEAK
References: <20100126175719.7820.74641.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20100126175719.7820.74641.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Catalin Marinas kirjoitti:
> This is a fix for bug #14845 (bugzilla.kernel.org). The
> update_checksum() function in mm/kmemleak.c calls
> kmemcheck_is_obj_initialised() before scanning an object. When
> KMEMCHECK_PARTIAL_OK is enabled, this function returns true. However,
> the crc32_le() reads smaller intervals (32-bit) for which
> kmemleak_is_obj_initialised() is may be false leading to a kmemcheck
> warning.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christian Casteyde <casteyde.christian@free.fr>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  lib/Kconfig.kmemcheck |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/lib/Kconfig.kmemcheck b/lib/Kconfig.kmemcheck
> index 846e039..80660e9 100644
> --- a/lib/Kconfig.kmemcheck
> +++ b/lib/Kconfig.kmemcheck
> @@ -75,7 +75,7 @@ config KMEMCHECK_SHADOW_COPY_SHIFT
>  config KMEMCHECK_PARTIAL_OK
>  	bool "kmemcheck: allow partially uninitialized memory"
>  	depends on KMEMCHECK
> -	default y
> +	default y if !DEBUG_KMEMLEAK
>  	help
>  	  This option works around certain GCC optimizations that produce
>  	  32-bit reads from 16-bit variables where the upper 16 bits are
> 

Disabling KMEMCHECK_PARTIAL_OK can cause other false positives so maybe 
we should add a new function to kmemcheck for kmemleak that only reads 
full intervals?
