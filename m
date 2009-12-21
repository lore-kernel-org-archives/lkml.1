Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbZLUQsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbZLUQsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 11:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbZLUQsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 11:48:31 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:54483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbZLUQsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 11:48:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Fix BUILD_BUG_ON in fs/compat_ioctl.c to build with gcc 4.5 snapshot
Date: Mon, 21 Dec 2009 17:48:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, rusty@rustcorp.com.au, rguenther@suse.de
References: <20091220165315.GA13208@basil.fritz.box>
In-Reply-To: <20091220165315.GA13208@basil.fritz.box>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912211748.13017.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19aqqz7nKN7lJyPgeFQgmV2jVHd81Cj6tzazJI
 pJVNUMawiNw6Z/osUGC2pz1krdFfHNghgsyI9vOGEIrjmmKuFD
 AMIBPgazjfRaAmPYYXuZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 December 2009, Andi Kleen wrote:
> ===================================================================
> --- linux-2.6.33-rc1-ak.orig/fs/compat_ioctl.c
> +++ linux-2.6.33-rc1-ak/fs/compat_ioctl.c
> @@ -1649,8 +1649,10 @@ static int compat_ioctl_check_table(unsi
>  {
>         int i;
>         const int max = ARRAY_SIZE(ioctl_pointer) - 1;
> +       extern void __ioctl_pointer_too_large(void);
>  
> -       BUILD_BUG_ON(max >= (1 << 16));
> +       if (max >= (1 << 16))
> +               __ioctl_pointer_too_large();
>  
>         /* guess initial offset into table, assuming a
>            normalized distribution */

Acked-by: Arnd Bergmann <arnd@arndb.de>
