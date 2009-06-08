Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbZFHMyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbZFHMyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 08:54:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZFHMx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 08:53:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35697 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbZFHMx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:53:59 -0400
Date: Mon, 8 Jun 2009 08:53:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] proc: vmcore - use kzalloc in get_new_element
Message-ID: <20090608125359.GA3652@redhat.com>
References: <20090606171207.GC20807@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090606171207.GC20807@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 06, 2009 at 09:12:07PM +0400, Cyrill Gorcunov wrote:
> Instead of kmalloc+memset better use straight kzalloc
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  fs/proc/vmcore.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> Index: linux-2.6.git/fs/proc/vmcore.c
> =====================================================================
> --- linux-2.6.git.orig/fs/proc/vmcore.c
> +++ linux-2.6.git/fs/proc/vmcore.c
> @@ -166,12 +166,7 @@ static const struct file_operations proc
>  
>  static struct vmcore* __init get_new_element(void)
>  {
> -	struct vmcore *p;
> -
> -	p = kmalloc(sizeof(*p), GFP_KERNEL);
> -	if (p)
> -		memset(p, 0, sizeof(*p));
> -	return p;
> +	return kzalloc(sizeof(struct vmcore), GFP_KERNEL);
>  }
>  
>  static u64 __init get_vmcore_size_elf64(char *elfptr)

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

