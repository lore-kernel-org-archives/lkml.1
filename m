Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbXLFWbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbXLFWbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:31:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXLFWb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:31:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752334AbXLFWb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:31:29 -0500
Message-ID: <47587995.4000403@redhat.com>
Date: Thu, 06 Dec 2007 17:37:09 -0500
From: Dave Anderson <anderson@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030611
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, anderson@redhat.com
Subject: Re: [NEW-PATCH] exec: allow > 2GB executables to run on 64-bit systems
References: <4756C590.9080301@redhat.com> <p73fxyhj5f7.fsf@bingen.suse.de> <475702E7.1000607@redhat.com> <20071205195637.GA20595@one.firstfloor.org> <47570B0A.6040404@redhat.com> <20071206221520.GG20595@one.firstfloor.org>
In-Reply-To: <20071206221520.GG20595@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Since Dave didn't post an updated patch. This is how I think what
> the patch should be. I also changed sys_uselib just to be complete.
> 

Thanks Andi -- I just tested open_exec() w/O_LARGEFILE on an
i386 with a 2.5GB+ binary (mostly debuginfo), and it works as
expected.  Interesting to note that the test binary couldn't
be compiled with i386 gcc, but it could be built with x86_64
gcc -m32.

Dave


> ----
> 
> 
> Always use O_LARGEFILE for opening executables
> 
> This allows to use executables >2GB.
> 
> Based on a patch by Dave Anderson
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> 
> Index: linux-2.6.24-rc3/fs/exec.c
> ===================================================================
> --- linux-2.6.24-rc3.orig/fs/exec.c
> +++ linux-2.6.24-rc3/fs/exec.c
> @@ -119,7 +119,7 @@ asmlinkage long sys_uselib(const char __
>  	if (error)
>  		goto exit;
>  
> -	file = nameidata_to_filp(&nd, O_RDONLY);
> +	file = nameidata_to_filp(&nd, O_RDONLY|O_LARGEFILE);
>  	error = PTR_ERR(file);
>  	if (IS_ERR(file))
>  		goto out;
> @@ -658,7 +658,8 @@ struct file *open_exec(const char *name)
>  			int err = vfs_permission(&nd, MAY_EXEC);
>  			file = ERR_PTR(err);
>  			if (!err) {
> -				file = nameidata_to_filp(&nd, O_RDONLY);
> +				file = nameidata_to_filp(&nd,
> +							O_RDONLY|O_LARGEFILE);
>  				if (!IS_ERR(file)) {
>  					err = deny_write_access(file);
>  					if (err) {


