Return-Path: <linux-kernel-owner+w=401wt.eu-S934092AbYEBAvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934092AbYEBAvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 20:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754730AbYEBAut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 20:50:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754141AbYEBAus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 20:50:48 -0400
Date: Thu, 1 May 2008 17:50:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josselin Mouette <joss@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Increase the default RLIMIT_MEMLOCK
Message-Id: <20080501175037.01d8d3dc.akpm@linux-foundation.org>
In-Reply-To: <1209324387.4203.22.camel@shizuru>
References: <1209324387.4203.22.camel@shizuru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Apr 2008 21:26:27 +0200
Josselin Mouette <joss@debian.org> wrote:

> Currently, the default value for RLIMIT_MEMLOCK (defined in
> include/linux/resource.h) is 32 KiB, because this value is enough for
> GnuPG.
> 
> However this value is not enough for gnome-keyring-daemon, which will
> store both SSH and GnuPG keys, plus user passwords for various kinds of
> resources. Upstream authors recommend to provide a limit of at least 256
> KiB for RLIMIT_MEMLOCK for the keys to remain securely in memory.
> 
> Given the amount of memory in current machines, I think 256 KiB is still
> a very reasonable value. What do you think of increasing this default
> value in the kernel?
> 
> Cheers,
> -- 
>  .''`.
> : :' :      We are debian.org. Lower your prices, surrender your code.
> `. `'       We will add your hardware and software distinctiveness to
>   `-        our own. Resistance is futile.
> 
> 
> [linux_mlock_256k.patch  text/x-patch (668B)]
> --- include/linux/resource.h.orig	2008-04-27 21:15:47.000000000 +0200
> +++ include/linux/resource.h	2008-04-27 21:23:06.000000000 +0200
> @@ -58,10 +58,11 @@
>  #define _STK_LIM	(8*1024*1024)
>  
>  /*
> - * GPG wants 32kB of mlocked memory, to make sure pass phrases
> - * and other sensitive information are never written to disk.
> + * The biggest widespread mlocked memory consumer is 
> + * gnome-keyring-manager. It needs 256kB to make sure SSH/GPG 
> + * passphrases and network passwords are never written to disk.
>   */
> -#define MLOCK_LIMIT	(8 * PAGE_SIZE)
> +#define MLOCK_LIMIT	(64 * PAGE_SIZE)

gee, it seems rather arbitrary.  Perhaps we should have set it to zero on
day one to _force_ distributors to set an appropriate RLIMIT_MEMLOCK in
init.

We can do this of course, but does it actually help anything?  Perhaps it's
actually a bad thing, permitting userspace developers to rely upon kernel
defaults rather than setting things they way they should be set?

