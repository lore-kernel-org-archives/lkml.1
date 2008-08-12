Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYHLVqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYHLVqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbYHLVqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:46:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34961 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbYHLVqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:46:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: Re: [PATCH] suspend: fix section mismatch warning - register_nosave_region
Date: Tue, 12 Aug 2008 23:49:25 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       Len Brown <len.brown@intel.com>, Andrew Morton <akpm@google.com>
References: <1218576186-31442-4-git-send-email-marcin.slusarz@gmail.com>
In-Reply-To: <1218576186-31442-4-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122349.26256.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Marcin Slusarz wrote:
> WARNING: vmlinux.o(.text+0xe684): Section mismatch in reference from the function register_nosave_region() to the function .init.text:__register_nosave_region()
> The function register_nosave_region() references
> the function __init __register_nosave_region().
> This is often because register_nosave_region lacks a __init
> annotation or the annotation of __register_nosave_region is wrong.
> 
> register_nosave_region calls __init function and is called only from __init functions
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Pavel Machek <pavel@suse.cz>
> Cc: Len Brown <len.brown@intel.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  include/linux/suspend.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/suspend.h b/include/linux/suspend.h
> index c634350..2ce8207 100644
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -217,11 +217,11 @@ struct platform_hibernation_ops {
>  #ifdef CONFIG_HIBERNATION
>  /* kernel/power/snapshot.c */
>  extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
> -static inline void register_nosave_region(unsigned long b, unsigned long e)
> +static inline void __init register_nosave_region(unsigned long b, unsigned long e)
>  {
>  	__register_nosave_region(b, e, 0);
>  }
> -static inline void register_nosave_region_late(unsigned long b, unsigned long e)
> +static inline void __init register_nosave_region_late(unsigned long b, unsigned long e)
>  {
>  	__register_nosave_region(b, e, 1);
>  }


