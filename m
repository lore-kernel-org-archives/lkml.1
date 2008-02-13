Return-Path: <linux-kernel-owner+w=401wt.eu-S1757003AbYBMI5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003AbYBMI5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbYBMI53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:57:29 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:52208 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976AbYBMI52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:57:28 -0500
Date: Wed, 13 Feb 2008 09:57:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Make LMB code sharable with sparc64.
Message-ID: <20080213085735.GB8091@uranus.ravnborg.org>
References: <20080213.004120.22092044.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213.004120.22092044.davem@davemloft.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 12:41:20AM -0800, David Miller wrote:
> 
> As I mentioned to a few ppc folks at LCA08 I plan to use
> the LMB code from powerpc as a basis for NUMA support on
> sparc64.
> 
> There are two changes.
> 
> 1) Move arch/powerpc/mm/lmb.c to lib/lmb.c, put the main
>    interface bits in include/linux/lmb.h, put arch-specific
>    bits in asm/lmb.h and add Kconfig machinery to build this
>    stuff on sparc64.
> 
> 2) Fix a bug in lmb_alloc() wherein the size was not aligned
>    so we could easily run out of reserve blocks because
>    every aligned allocation would create a tiny hole, and
>    secondly the lmb_reserve() call there did not have it's
>    return value checked.
> 
> Powerpc folks, if there are no objections please pull, thanks!
> 
> The following changes since commit 96b5a46e2a72dc1829370c87053e0cd558d58bc0:
>   Linus Torvalds (1):
>         WMI: initialize wmi_blocks.list even if ACPI is disabled
> 
> are available in the git repository at:
> 
>   master.kernel.org:/pub/scm/linux/kernel/git/davem/lmb-2.6.git master

Review had been easier if the patch was inlined.
Took a quick look at the small Kconfig bits.

>From arch/sparc64/Kconfig:
+config LMB
+       def_bool y
+

Can we plase have this changed to use:

 config SPARC64
+	select HAVE_LMB

And then in lib/Kconfig have
+config HAVE_LMB
+	bool

So we avoid creating a new variable each time we introdce LMB support.
You would need to update powerpc Kconfig too of course.

This way of doing it is documented in:
Documenation/kbuild/kconfig.language.txt

Thanks,
	Sam
