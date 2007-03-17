Return-Path: <linux-kernel-owner+w=401wt.eu-S933669AbXCQFhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933669AbXCQFhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 01:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933665AbXCQFhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 01:37:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56461 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933669AbXCQFhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 01:37:53 -0400
Date: Sat, 17 Mar 2007 11:07:08 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: prasanna@in.ibm.com, anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kprobes: fix sparse NULL warning
Message-ID: <20070317053708.GA9803@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20070316183436.eb25034e.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070316183436.eb25034e.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2007 at 06:34:36PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix sparse NULL warnings:
> kernel/kprobes.c:915:49: warning: Using plain integer as NULL pointer

Thanks for catching this Randy.
 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
>  kernel/kprobes.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2621-rc4.orig/kernel/kprobes.c
> +++ linux-2621-rc4/kernel/kprobes.c
> @@ -35,6 +35,7 @@
>  #include <linux/hash.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> +#include <linux/stddef.h>
>  #include <linux/module.h>
>  #include <linux/moduleloader.h>
>  #include <linux/kallsyms.h>
> @@ -912,7 +913,7 @@ static int __kprobes debugfs_kprobe_init
>  	if (!dir)
>  		return -ENOMEM;
> 
> -	file = debugfs_create_file("list", 0444, dir , 0 ,
> +	file = debugfs_create_file("list", 0444, dir, NULL,
>  				&debugfs_kprobes_operations);
>  	if (!file) {
>  		debugfs_remove(dir);
