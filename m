Return-Path: <linux-kernel-owner+w=401wt.eu-S932810AbXHVSLc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810AbXHVSLc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762792AbXHVSLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:11:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42884 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761078AbXHVSLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:11:21 -0400
Date: Wed, 22 Aug 2007 11:10:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070822111029.46db0ab7.akpm@linux-foundation.org>
In-Reply-To: <46CC6FB2.1010801@csn.ul.ie>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CC6FB2.1010801@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2007 18:17:38 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> Andrew Morton wrote:
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> > 
> > - git-ixgbe.patch got dropped - git-net.patch destroyed it
> > 
> > - then git-net got dropped as it doesn't work
> > 
> > - the -mm import-to-git engine still isn't working
> > 
> 
> >From elm3b6 on test.kernel.org, we get the following build error
> 
> 08/22/07-07:01:07 building kernel - make bzImage
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86_64
>   CC      arch/x86_64/kernel/asm-offsets.s
> arch/x86_64/kernel/asm-offsets.c:1: error: -mpreferred-stack-boundary=3
> is not between 4 and 12
> make[1]: *** [arch/x86_64/kernel/asm-offsets.s] Error 1
> make: *** [prepare0] Error 2
> 08/22/07-07:01:08 Build the kernel. Failed rc = 2
> 08/22/07-07:01:08 build: Building kernel... Failed rc = 1
> Failed and terminated the run
> 08/22/07-07:01:08 command complete: (1) rc=126 (TEST ABORT)
>  Fatal error, aborting autorun
> 
> config file at: http://test.kernel.org/abat/107411/build/dotconfig
> gcc version is 3.4.4
> 
> This does not occur when using a cross-compiler gcc 3.4.0
> 

x86_64-mm-less-stack-alignment.patch has

cflags-y += $(call cc-option,-mpreferred-stack-boundary=3)

So we _should_ have detected that gcc didn't like =3, so it
should not have been used.

I am suspecting a kbuild glitch: asm-offsets.c tends to be handled
in special ways (ie: it's usually the thing which blows up first)
so perhaps it is somehow avoiding the above does-gcc-support-this test.

Suitable cc's added ;)
