Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab0BTOwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:52:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62123 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363Ab0BTOwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:52:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 07/18] sysctl extern cleanup - compat
Date: Sat, 20 Feb 2010 15:51:56 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.31-19-generic; KDE/4.4.0; x86_64; ; )
Cc: "David S. Miller" <davem@davemloft.net>, Gerd Hoffmann <kraxel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>
References: <20100220141328.GF3195@darkstar>
In-Reply-To: <20100220141328.GF3195@darkstar>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002201551.56851.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX188NlGgAQhAvugbEw9p7t4dAh/sgBHcbydXtKg
 DvP9fvNmvSpr3SeVnd2CHVC01McoaJZvhNuO0XFdfYu32dxDBY
 6SMBxo4xe0OiFlVxuuNzg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 February 2010 15:13:28 Dave Young wrote:
> Extern declarations in sysctl.c should be move to their own head file,
> and then include them in relavant .c files.
> 
> Move compat_log extern declaration to linux/compat.h
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

Good idea in principle, but please don't enclose the extern
declaration in #ifdef:

> --- linux-2.6.32.orig/include/linux/compat.h	2010-02-20 14:02:24.334925488 +0800
> +++ linux-2.6.32/include/linux/compat.h	2010-02-20 14:24:30.405627048 +0800
> @@ -17,6 +17,9 @@
>  #include <asm/siginfo.h>
>  #include <asm/signal.h>
>  
> +#ifdef CONFIG_SYSCTL
> +extern int compat_log;
> +#endif
>  #define compat_jiffies_to_clock_t(x)	\
>  		(((unsigned long)(x) * COMPAT_USER_HZ) / HZ)

This will force a rebuild of everything that #includes linux/compat.h when CONFIG_SYSCTL
changes, while nothing really changes.

Obviously, the same goes for the entire series.

	Arnd
