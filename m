Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbYDRW0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbYDRW0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 18:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYDRW0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 18:26:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45017 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752420AbYDRW0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 18:26:21 -0400
Date: Fri, 18 Apr 2008 15:26:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>, Jason Wessel <jason.wessel@windriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kgdb: allow static kgdbts boot configuration
Message-Id: <20080418152609.c849fb7d.akpm@linux-foundation.org>
In-Reply-To: <200804181900.m3IJ0v3v011787@hera.kernel.org>
References: <200804181900.m3IJ0v3v011787@hera.kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 19:00:57 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=974460c5bfd9f6c38aa3dda189a63f9fc351035f
> Commit:     974460c5bfd9f6c38aa3dda189a63f9fc351035f
> Parent:     e3e2aaf7dc0d82a055e084cfd48b9257c0c66b68
> Author:     Jason Wessel <jason.wessel@windriver.com>
> AuthorDate: Thu Mar 20 13:43:44 2008 -0500
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu Apr 17 20:05:43 2008 +0200
> 
>     kgdb: allow static kgdbts boot configuration
>     
>     This patch adds in the ability to compile the kgdb internal test
>     string into the kernel so as to run the tests at boot without changing
>     the kernel boot arguments.  This patch also changes all the error
>     paths to invoke WARN_ON(1) which will emit the line number of the file
>     and dump the kernel stack when an error occurs.
>     
>     You can disable the tests in a kernel that is built this way
>     using "kgdbts="
>
> ...
>
> +#ifdef CONFIG_KGDB_TESTS_BOOT_STRING
> +static char config[MAX_CONFIG_LEN] = CONFIG_KGDB_TESTS_BOOT_STRING;
> +#else
>  static char config[MAX_CONFIG_LEN];
> +#endif

I expect that CONFIG_KGDB_TESTS_BOOT_STRING is always defined here.  Or if
not, that it is possible to arrange for that with sufficient Kconfig
cleverness.  If so, the ifdef shouldn't be needed.

> +config KGDB_TESTS_ON_BOOT
> +	bool "KGDB: Run tests on boot"
> +	depends on KGDB_TESTS
> +	default n
> +	help
> +	  Run the kgdb tests on boot up automatically without the need
> +	  to pass in a kernel parameter
> +
> +config KGDB_TESTS_BOOT_STRING
> +	string "KGDB: which internal kgdb tests to run"
> +	depends on KGDB_TESTS_ON_BOOT
> +	default "V1F100"
> +	help
> +	  This is the command string to send the kgdb test suite on
> +	  boot.  See the drivers/misc/kgdbts.c for detailed
> +	  information about other strings you could use beyond the
> +	  default of V1F100.

I dunno.  Do we *really* need this feature?  I mean, if you want to run the
tests, you provide the boot parameter and that's it.  Adding this
Kconfig-time stuff on top seems excessive.

