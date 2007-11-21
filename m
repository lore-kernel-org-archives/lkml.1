Return-Path: <linux-kernel-owner+w=401wt.eu-S1756572AbXKYR0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbXKYR0d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 12:26:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbXKYR00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 12:26:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3589 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753331AbXKYR0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:26:25 -0500
Date: Wed, 21 Nov 2007 18:03:38 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Reichelt <mail@itamservices.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Patch: Hide process info from other users/users not in my group
Message-ID: <20071121180338.GB3888@ucw.cz>
References: <4742B82C.3060001@itamservices.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4742B82C.3060001@itamservices.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> this patch sets (if the corresponding kconfig option is active) the access
> modes of /proc/<pid>-dirs to 550 instead of 555 in order to provide some
> privacy to users. Tools like lsof and ps to spy out on other users become
> ineffective.
> 
> Cheers,
> --
> Daniel Reichelt
> 
> # diff -Naur linux-2.6.23.8/fs/Kconfig linux-2.6.23.8-dhr/fs/Kconfig
> --- linux-2.6.23.8/fs/Kconfig   2007-11-16 19:14:27.000000000 +0100
> +++ linux-2.6.23.8-dhr/fs/Kconfig       2007-11-20 11:33:18.000000000 +0100
> @@ -918,6 +918,17 @@
>          help
>          Exports the dump image of crashed kernel in ELF format.
> 
> +config PROC_SECURED_PID_DIRS
> +       bool "chmod /proc/<pid>-dirs to 550"
> +       depends on PROC_FS
> +       default n
> +       help
> +         chmod /proc/<pid>-dirs to 550 instead of 555 which provides a bit
> +         moreprivacy to users on your system as only the user's and the user's
> +         group's process details may be viewed. Other users' tasks running on
> +         the system will be completely hidden from the means of utilities like
> +         ps or lsof.
> +

This really needs to be runtime-configurable.

-- 
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
