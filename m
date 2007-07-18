Return-Path: <linux-kernel-owner+w=401wt.eu-S1764318AbXGRRCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764318AbXGRRCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 13:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbXGRRCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 13:02:09 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:41761 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXGRRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 13:02:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qvAVnGJIYhEhAQAuzAGfBniueybEziF5zdk3QXc0Nx7a3lGWh8z9/pfNT7kh1n0gjtvLQ/6QU5gY9sHKhbBc9aHeWRCDchX/zxha0kwtKjjYBi/3uchp9FxkntLCm33Dzqwh5XWgteYQMwDYGJoi0gIE5ATae04A/V2VYT5sIt4=
Message-ID: <dda83e780707181002t8cb734ep5d5e42ebde5d617a@mail.gmail.com>
Date: Wed, 18 Jul 2007 10:02:06 -0700
From: "Bret Towe" <magnade@gmail.com>
To: "Tony Breeds" <tony@bakeyournoodle.com>
Subject: Re: [PATCH] Re: 2.6.22-git ppc build failure
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070718010355.GV10345@bakeyournoodle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dda83e780707171104g10372341l7d2225f172153a6b@mail.gmail.com>
	 <20070718010355.GV10345@bakeyournoodle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Tony Breeds <tony@bakeyournoodle.com> wrote:
> On Tue, Jul 17, 2007 at 11:04:57AM -0700, Bret Towe wrote:
> > this is off my g4 mac mini
> > latest git as of when this email was sent
> > config file attached
>
> Hi Bret,
>         the patch below will fix it.

yeap it compiled and boots fine
thanks


> From: Tony Breeds <tony@bakeyournoodle.com>
>
> Fix compile failure in arch/powerpc/kernel/pci-common.c
>
>  CC      arch/powerpc/kernel/pci-common.o
> arch/powerpc/kernel/pci-common.c:160: error: conflicting types for 'pcibios_add_platform_entries'
> include/linux/pci.h:889: error: previous declaration of 'pcibios_add_platform_entries' was here
>
> Fallout from the powerpc merge (489de30259e667d7bc47da9da44a0270b050cd97).
>
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
>
> ---
>  arch/powerpc/kernel/pci-common.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> Index: working/arch/powerpc/kernel/pci-common.c
> ===================================================================
> --- working.orig/arch/powerpc/kernel/pci-common.c       2007-07-18 10:34:55.000000000 +1000
> +++ working/arch/powerpc/kernel/pci-common.c    2007-07-18 10:39:19.000000000 +1000
> @@ -156,11 +156,14 @@ static DEVICE_ATTR(devspec, S_IRUGO, pci
>  #endif /* CONFIG_PPC_OF */
>
>  /* Add sysfs properties */
> -void pcibios_add_platform_entries(struct pci_dev *pdev)
> +int pcibios_add_platform_entries(struct pci_dev *pdev)
>  {
>  #ifdef CONFIG_PPC_OF
> -       device_create_file(&pdev->dev, &dev_attr_devspec);
> +       return device_create_file(&pdev->dev, &dev_attr_devspec);
> +#else
> +       return 0;
>  #endif /* CONFIG_PPC_OF */
> +
>  }
>
>  char __init *pcibios_setup(char *str)
>
> Yours Tony
>
>   linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
>   Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!
>
>
