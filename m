Return-Path: <linux-kernel-owner+w=401wt.eu-S1758947AbZIQHjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947AbZIQHjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbZIQHjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:39:24 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:56503 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758202AbZIQHjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:39:23 -0400
Message-ID: <4AB1E78D.3070007@snapgear.com>
Date: Thu, 17 Sep 2009 17:38:53 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] Actually show KiB rather than pages in "Freeing initrd
 memory:" message on h3800, m68knommu and microblaze.
References: <20090915165037.GA23702@csclub.uwaterloo.ca>
In-Reply-To: <20090915165037.GA23702@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennart,

Lennart Sorensen wrote:
> Fix "Freeing initrd memory:" message on h3800, m68knommu and microblaze
> to show kilobytes as claimed rather than number of pages.
> 
> Signed-off-by: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>

Looks ok to me. I can take and push the m68knommu part separately.
Or if Andrew wants to take it all as one, here is an:

Acked-by: Greg Ungerer <gerg@uclinux.org>


Regards
Greg


> diff --git a/arch/h8300/mm/init.c b/arch/h8300/mm/init.c
> index 9942f24..3342f49 100644
> --- a/arch/h8300/mm/init.c
> +++ b/arch/h8300/mm/init.c
> @@ -170,7 +170,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>  		totalram_pages++;
>  		pages++;
>  	}
> -	printk ("Freeing initrd memory: %dk freed\n", pages);
> +	printk ("Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
>  }
>  #endif
>  
> diff --git a/arch/m68knommu/mm/init.c b/arch/m68knommu/mm/init.c
> index b1703c6..f3236d0 100644
> --- a/arch/m68knommu/mm/init.c
> +++ b/arch/m68knommu/mm/init.c
> @@ -162,7 +162,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>  		totalram_pages++;
>  		pages++;
>  	}
> -	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
> +	printk (KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
>  }
>  #endif
>  
> diff --git a/arch/microblaze/mm/init.c b/arch/microblaze/mm/init.c
> index f207f1a..ed5f96b 100644
> --- a/arch/microblaze/mm/init.c
> +++ b/arch/microblaze/mm/init.c
> @@ -180,7 +180,7 @@ void free_initrd_mem(unsigned long start, unsigned long end)
>  		totalram_pages++;
>  		pages++;
>  	}
> -	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages);
> +	printk(KERN_NOTICE "Freeing initrd memory: %dk freed\n", pages * (PAGE_SIZE / 1024));
>  }
>  #endif
>  
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
