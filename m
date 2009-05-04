Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZEDH6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZEDH6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 03:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZEDH60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 03:58:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:33235 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZEDH6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 03:58:25 -0400
Date: Mon, 4 May 2009 09:58:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Anders Kaseorg <andersk@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
Message-ID: <20090504095810.18c1fa6d@hyperion.delvare>
In-Reply-To: <20090503202939.GA1237@uranus.ravnborg.org>
References: <20090503110517.6d09bca2@hyperion.delvare>
	<20090503103010.GA27978@uranus.ravnborg.org>
	<20090503124848.276b437f@hyperion.delvare>
	<20090503180332.GA31820@uranus.ravnborg.org>
	<20090503202939.GA1237@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Sun, 3 May 2009 22:29:39 +0200, Sam Ravnborg wrote:
> This is due to the SUSE specific section as you expected.
> We ignore sections named ".comment" but not ".comment" sections
> with something appended to the name.
> 
> Can you please try appended patch and let me know if it fixes it for you.
> 
> Thanks,
> 	Sam
> 
> From 73aa9cbd4f71afdb173605383f77ebfda6d19ced Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sun, 3 May 2009 22:17:37 +0200
> Subject: [PATCH 2/2] kbuild, modpost: fix "unexpected non-allocatable" warning with SUSE gcc
> 
> Jean reported that he saw one warning for each module like the one below:
> WARNING: arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.o (.comment.SUSE.OPTs): unexpected non-allocatable section.
> 
> The warning appeared with the improved version of the
> check of the flags in the sections.
> 
> That check already ignored sections named ".comment" - but SUSE store
> additional info in the comment section and has named it in a SUSE
> specific way. Therefore modpost failed to ignore the section.
> 
> The fix is to extend the pattern so we ignore all sections
> that start with the name ".comment.".
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Reported-by: Jean Delvare <khali@linux-fr.org>
> ---
>  scripts/mod/modpost.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index a5c17db..268d457 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -727,7 +727,7 @@ int match(const char *sym, const char * const pat[])
>  
>  /* sections that we do not want to do full section mismatch check on */
>  static const char *section_white_list[] =
> -	{ ".comment", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
> +	{ ".comment*", ".debug*", ".stab*", ".note*", ".got*", ".toc*", NULL };
>  
>  /*
>   * This is used to find sections missing the SHF_ALLOC flag.

Yes, it fixes my problem. Thanks for the quick fix! Please push this
upstream quickly.

-- 
Jean Delvare
