Return-Path: <linux-kernel-owner+w=401wt.eu-S1763012AbXGKLOB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763012AbXGKLOB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:14:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbXGKLNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:13:53 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:58003 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758959AbXGKLNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:13:53 -0400
Date: Wed, 11 Jul 2007 13:13:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Message-ID: <20070711111350.GI7091@elf.ucw.cz>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1184167831.12556.13.camel@caritas-dev.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Looks interesting... but I was feeling strange dejavu reading
this... and that's because you pasted the changelog twice :-).

> Kexec base hibernation has some potential advantages over uswsusp and
> suspend2. Some most obvious advantages are:
> 
> 1. The hibernation image size can exceed half of memory size easily.

Yes.

> 2. The hibernation image can be written to and read from almost
>    anywhere, such as USB disk, NFS.

We could do USB disk with uswsusp... NFS would be harder.

How fast can kexec boot secondary kernel?

> This patch implements the functionality of "jumping from kexeced
> kernel to original kernel". That is, the following sequence is
> possible:
> 
> 1. Boot a kernel A
> 2. Work under kernel A
> 3. Kexec another kernel B in kernel A
> 4. Work under kernel B
> 5. Jump from kernel B to kernel A
> 6. Continue work under kernel A

Nice!

> 2. Compile the kexec-tools with kdump and kjump patches added, the
>    kdump patch can be found at:
> 
> http://lse.sourceforge.net/kdump/patches/kexec-tools-1.101-dkump10.patch

I got 404 error :-(.

> 3. Boot compiled kernel, the reserved crash kernel memory region must
>    be added to kernel command line as following:
> 
>    crashkernel=<XX>M@<XX>M
> 
>    Where, <XX> should be replaced by the real memory size and position.

How much memory do you suggest to reserve? 64M? 

> 7. In the kexec booted kernel, trigger the jumping back with following
>    shell command.
> 
>    echo <a>:<b> > /sys/power/resume
> 
>    Where <a> and <b> is non-negative integer, at least one of them must
>    be non-zero.

What does a and b mean?

[Was it more than three copies? If they were non-identical, assume I
read some random one].

> +/* Adds the kexec_backup= command line parameter to command line. */
> +static int cmdline_add_backup(char *cmdline, unsigned long addr)
> +{
> +	int cmdlen, len, align = 1024;
> +	char str[30], *ptr;
> +
> +	/* Passing in kexec_backup=xxxK format. Saves space required in cmdline.
> +	 * Ensure 1K alignment*/
> +	if (addr%align)
> +		return -1;
> +	addr = addr/align;
> +	ptr = str;
> +	strcpy(str, " kexec_backup=");
> +	ptr += strlen(str);
> +	ultoa(addr, ptr);
> +	strcat(str, "K");
> +	len = strlen(str);
> +	cmdlen = strlen(cmdline) + len;
> +	if (cmdlen > (COMMAND_LINE_SIZE - 1))
> +		die("Command line overflow\n");
> +	strcat(cmdline, str);
> +#if 0
> +		printf("Command line after adding backup\n");
> +		printf("%s\n", cmdline);
> +#endif
> +	return 0;
> +}

printf()? ...and please remove out commented code.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
