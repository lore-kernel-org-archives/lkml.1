Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYKSG06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYKSG06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:26:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751030AbYKSG0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:26:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751021AbYKSG0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:26:49 -0500
Date: Tue, 18 Nov 2008 22:26:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] genrtc: disable genrtc on Blackfin systems
Message-Id: <20081118222633.2cf8e231.akpm@linux-foundation.org>
In-Reply-To: <1226991615-30268-1-git-send-email-cooloney@kernel.org>
References: <1226991615-30268-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 15:00:15 +0800 Bryan Wu <cooloney@kernel.org> wrote:

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>

What is the reason for this change?

> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 43d6ba8..a92a60a 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -814,7 +814,7 @@ config JS_RTC
>  
>  config GEN_RTC
>  	tristate "Generic /dev/rtc emulation"
> -	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32
> +	depends on RTC!=y && !IA64 && !ARM && !M32R && !MIPS && !SPARC && !FRV && !S390 && !SUPERH && !AVR32 && !BLACKFIN

Gawd that's stupid.  It'd be much better to add a new
CONFIG_ARCH_SUPPORTS_GENRTC in arch/*/Kconfig.

Oh well.  I suppose we can run with this patch for now.  Once we know
what it's for.

