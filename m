Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbYABPOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbYABPOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:14:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYABPNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:13:54 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59106 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412AbYABPNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:13:53 -0500
Date: Wed, 2 Jan 2008 17:13:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] linux/{socket,stat}.h: change __GLIBC__ cruft to
	__KLIBC__
Message-ID: <20080102151335.GA15898@does.not.exist>
References: <200801020937.50770.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200801020937.50770.vapier@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 09:37:50AM -0500, Mike Frysinger wrote:
> The __GLIBC__ hacks were re-added to the headers because the klibc peeps want
> to be lazy.  But rather than properly address things, they just wrongly left
> it as __GLIBC__.  This patch changes the __GLIBC__ cruft to __KLIBC__ so real
> libcs don't get screwed due to kilbc's laziness.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index c22ef1c..90af15b 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -16,7 +16,7 @@ struct __kernel_sockaddr_storage {
>  				/* _SS_MAXSIZE value minus size of ss_family */
>  } __attribute__ ((aligned(_K_SS_ALIGNSIZE)));	/* force desired alignment */
>  
> -#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
> +#if defined(__KERNEL__) || defined(__KLIBC__)
>...

This changes the semantics from "!glibc" to "klibc".

I'm a bit worried that such changes might break some of the other 
libc's people use on Linux.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

