Return-Path: <linux-kernel-owner+w=401wt.eu-S1762847AbXKIEhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762847AbXKIEhK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 23:37:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759927AbXKIEgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 23:36:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762321AbXKIEgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 23:36:35 -0500
Date: Thu, 8 Nov 2007 20:36:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] init: Introduce rootdir bootparm to select which dir to
 sys_chroot
Message-Id: <20071108203618.99741428.akpm@linux-foundation.org>
In-Reply-To: <200711061340.26112.a1426z@gawab.com>
References: <200711061340.26112.a1426z@gawab.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 6 Nov 2007 13:40:26 +0300 Al Boldi <a1426z@gawab.com> wrote:
> 
> This patch introduces a rootdir kernel boot parameter, which specifies the 
> path to the kernel sys_chroot boot dir.
> 
> This is useful for systems that have more than one distribution installed on 
> the same fs/partition.
> 
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Al Boldi <a1426z@gawab.com>
> 
> ---
> 
> --- a/init/do_mounts.c
> +++ b/init/do_mounts.c
> @@ -252,6 +252,15 @@ __setup("rootflags=", root_data_setup);
>  __setup("rootfstype=", fs_names_setup);
>  __setup("rootdelay=", root_delay_setup);
>  
> +static char * __initdata root_dir;
> +static int __init root_dir_setup(char *str)
> +{
> +	root_dir = strcat("./",str);
> +	return 1;
> +}
> +
> +__setup("rootdir=", root_dir_setup);

Please update Documentation/kernel-parameters.txt when adding __setup
options.

>  static void __init get_fs_names(char *page)
>  {
>  	char *s = page;
> @@ -469,6 +478,10 @@ void __init prepare_namespace(void)
>  	mount_root();
>  out:
>  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
> +
> +	if(root_dir)
> +		sys_chdir(root_dir);
> +

Please run scripts/checkpatch.pl across all patches before sending them to
anyone.

