Return-Path: <linux-kernel-owner+w=401wt.eu-S1759424AbZLJIpy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbZLJIpy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 03:45:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbZLJIpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 03:45:24 -0500
Received: from poutre.nerim.net ([62.4.16.124]:59203 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608AbZLJIpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 03:45:21 -0500
Date: Thu, 10 Dec 2009 09:45:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Etienne Le Sueur <elesueur@cse.unsw.edu.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/char/nvram.c: Undo removal of duplicated
 include
Message-ID: <20091210094525.134c1d16@hyperion.delvare>
In-Reply-To: <4B205745.7060704@cse.unsw.edu.au>
References: <4B205745.7060704@cse.unsw.edu.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Etienne,

On Thu, 10 Dec 2009 13:04:53 +1100, Etienne Le Sueur wrote:
> elesueur@bitburger:/usr/src/linux-2.6-git$ make
>    CHK     include/linux/version.h
>    CHK     include/linux/utsrelease.h
>    SYMLINK include/asm -> include/asm-x86
>    CALL    scripts/checksyscalls.sh
>    CHK     include/linux/compile.h
>    CC      drivers/char/consolemap_deftbl.o
>    CC      drivers/char/defkeymap.o
>    LD      drivers/char/built-in.o
>    CC [M]  drivers/char/nvram.o
> drivers/char/nvram.c: In function 'nvram_open':
> drivers/char/nvram.c:332: error: implicit declaration of function 
> 'lock_kernel'
> drivers/char/nvram.c:339: error: implicit declaration of function 
> 'unlock_kernel'
> make[2]: *** [drivers/char/nvram.o] Error 1
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
> 
> a check shows commit id: 4d8f54d9e4323baae8c8ca753db91563f4b34ddb 
> removed a 'duplicated include' which I believe is erroneous.
> 
> 
> 
> 
> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
> index 2100a8f..3cfa0f6 100644
> --- a/drivers/char/nvram.c
> +++ b/drivers/char/nvram.c
> @@ -38,6 +38,7 @@
>   #define NVRAM_VERSION  "1.3"
> 
>   #include <linux/module.h>
> +#include <linux/smp_lock.h>
>   #include <linux/nvram.h>
> 
>   #define PC             1

Your patch got corrupted so it won't apply.

Anyway it seems this build error is already fixed upstream:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=79a56ed0e11c7d924762062a0e2a46b87014498d

-- 
Jean Delvare
