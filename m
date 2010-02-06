Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0BFI6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 03:58:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50576 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab0BFI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 03:58:38 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] compat ioctl: fix some build warnings
Date: Sat, 6 Feb 2010 09:58:16 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       Alexander Viro <viro@zeniv.linux.org.uk>
References: <20100205070921.4179.39579.sendpatchset@localhost.localdomain> <20100205140150.7f5df97b.akpm@linux-foundation.org>
In-Reply-To: <20100205140150.7f5df97b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002060958.16360.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/f35YvO16L5sYekuMlRfbJ9JSqNUGdV/x4alI
 mtQ1+dqacLloiix0f3dhb2GUq6fPHnWG0ggRp9ZMUmTyQQuKQM
 49CCwHSgF4gZSmy5eqjIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 February 2010, Andrew Morton wrote:
> Unfortunately that adds more code for something which cannot happen at
> runtime.
> 
> I guess we could do this trick:
> 
> --- a/fs/compat_ioctl.c~a
> +++ a/fs/compat_ioctl.c
> @@ -539,7 +539,7 @@ static int mt_ioctl_trans(unsigned int f
>                 kcmd = MTIOCPOS;
>                 karg = &pos;
>                 break;
> -       case MTIOCGET32:
> +       default:        /* MTIOCGET32 */
>                 kcmd = MTIOCGET;
>                 karg = &get;
>                 break;
> @@ -657,7 +657,7 @@ static int raw_ioctl(unsigned fd, unsign
>  
>          switch (cmd) {
>          case RAW_SETBIND:
> -        case RAW_GETBIND: {
> +        default: {     /* RAW_GETBIND */
>                  struct raw_config_request req;
>                  mm_segment_t oldfs = get_fs();
>  

Looks good to me. Actually, we could just kill the switch/case
statement in raw_ioctl entirely, but I wouldn't bother at this
point any more because there are already patches from both Al
and me to kill that function by moving it into drivers/char/raw.c

I need to check what happened to that patch and to the other
patches I have removing code form fs/compat_ioctl.c, they might
need to be updated before I can submit them for the next merge.

In the meantime,

Acked-by: Arnd Bergmann <arnd@arndb.de>
