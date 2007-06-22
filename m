Return-Path: <linux-kernel-owner+w=401wt.eu-S1760090AbXFVSH2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090AbXFVSH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:07:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbXFVSHU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:07:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50724 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172AbXFVSHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:07:18 -0400
Date: Fri, 22 Jun 2007 13:05:01 -0500
From: David Teigland <teigland@redhat.com>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Subject: Re: [patch] DLM: fix kconfig dependency
Message-ID: <20070622180500.GD6381@redhat.com>
References: <20070622140615.GP5193@alberich.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070622140615.GP5193@alberich.amd.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 04:06:15PM +0200, Andreas Herrmann wrote:
> Avoid kernel build error (as DLM depends on SYSFS)
>     
>   LD      vmlinux
>   fs/built-in.o: In function `dlm_lockspace_init':
>   : undefined reference to `kernel_subsys'
>   fs/built-in.o: In function `configfs_init':
>   mount.c:(.init.text+0xef4): undefined reference to `kernel_subsys'
>     
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
> index 69a9469..c0e4c59 100644
> --- a/fs/dlm/Kconfig
> +++ b/fs/dlm/Kconfig
> @@ -1,5 +1,5 @@
>  menu "Distributed Lock Manager"
> -	depends on EXPERIMENTAL && INET
> +	depends on EXPERIMENTAL && INET && SYSFS
>  
>  config DLM
>  	tristate "Distributed Lock Manager (DLM)"

There's a been a lot of back and forth on this from a number of different
people:

1/18/06   depends on SYSFS
4/25/06 - depends on SYSFS
2/05/07 + select SYSFS
2/05/07 - select SYSFS
        + depends on SYSFS
5/01/07 - depends on SYSFS

It looks like the last removal was in error and it should be added back.

Dave

