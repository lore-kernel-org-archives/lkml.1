Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbYEIL7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbYEIL7u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 07:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753535AbYEIL7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 07:59:42 -0400
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:37596 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYEIL7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 07:59:41 -0400
X-Greylist: delayed 668 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 May 2008 07:59:41 EDT
Date: Fri, 9 May 2008 14:48:28 +0300
From: Niko Tyni <ntyni@debian.org>
To: linux-kernel@vger.kernel.org
Cc: 480130@bugs.debian.org
Subject: Re: m68knommu: rework definition of HZ
Message-ID: <20080509114828.GA10694@rebekka>
References: <fa.+a5tyUbZKH57Lq6WLCKJuVfWGU4@ifi.uio.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa.+a5tyUbZKH57Lq6WLCKJuVfWGU4@ifi.uio.no>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2008 at 02:21:45AM +0000, Greg Ungerer wrote:
> Rework the HZ definition to be more consistent with other architectures.
> Non-kernel includers will see a constant HZ setting of 100.

Something like this is needed for <asm-alpha/param.h> as well. 
Perl and possibly python too fail to build with the 2.6.25 header 
on alpha due to "'CONFIG_HZ' undeclared".

Some details can be found in http://bugs.debian.org/480130 .

> diff -Naurp linux-2.6.25/include/asm-m68knommu/param.h linux-2.6.25-uc0/include/asm-m68knommu/param.h
> --- linux-2.6.25/include/asm-m68knommu/param.h	2008-04-17 12:49:44.000000000 +1000
> +++ linux-2.6.25-uc0/include/asm-m68knommu/param.h	2008-04-28 17:00:21.000000000 +1000
> @@ -1,13 +1,16 @@
>  #ifndef _M68KNOMMU_PARAM_H
>  #define _M68KNOMMU_PARAM_H
>  
> -#define HZ CONFIG_HZ
> -
>  #ifdef __KERNEL__
> +#define HZ CONFIG_HZ
>  #define	USER_HZ		HZ
>  #define	CLOCKS_PER_SEC	(USER_HZ)
>  #endif
>  
> +#ifndef HZ
> +#define HZ	100
> +#endif
> +
>  #define EXEC_PAGESIZE	4096
>  
>  #ifndef NOGROUP

-- 
Niko Tyni   ntyni@debian.org
