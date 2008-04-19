Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYDSBuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYDSBuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 21:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYDSBtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 21:49:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbYDSBty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 21:49:54 -0400
Date: Fri, 18 Apr 2008 18:49:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: clean up non-smp usage of cpu maps
Message-Id: <20080418184921.87934c3f.akpm@linux-foundation.org>
In-Reply-To: <200804181736.m3IHatLo009568@hera.kernel.org>
References: <200804181736.m3IHatLo009568@hera.kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 17:36:55 GMT Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

>     x86: clean up non-smp usage of cpu maps
>     
>     Cleanup references to the early cpu maps for the non-SMP configuration
>     and remove some functions called for SMP configurations only.
>     
> ...
>
> index 1179aa0..dc79409 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -10,7 +10,7 @@
>  #include <asm/setup.h>
>  #include <asm/topology.h>
>  
> -#ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
> +#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)

This implies that we can have

	CONFIG_HAVE_SETUP_PER_CPU_AREA && !CONFIG_SMP

which a) appears to be true and b) seems rather dumb?
