Return-Path: <linux-kernel-owner+w=401wt.eu-S1763349AbXGUTaB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763349AbXGUTaB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:30:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXGUT3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:29:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12998 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbXGUT3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:29:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=i76IocZV2PVjH68v+n0HzK5yLVQV9pIv9jNoU2wj60aC/eknKHgQwJ+USZcaN880DdLJXbXwiN95k3YmNiKCXcHXeB9DFjIrj748hgyUQh+L/Px2i4O5J/NoScCWa7iMUTufimkhsW9seAPvg5d0Zl+xLe2QTeUQQsYXeTL+YvE=
Date: Sat, 21 Jul 2007 23:29:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] parse_table() earlier check.
Message-ID: <20070721192946.GA5772@martell.zuzino.mipt.ru>
References: <200707200337.l6K3bjDr053658@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707200337.l6K3bjDr053658@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 12:37:45PM +0900, Tetsuo Handa wrote:
> --- linux-2.6.22-orig/kernel/sysctl.c
> +++ linux-2.6.22/kernel/sysctl.c
> @@ -1190,9 +1190,9 @@
>  		return -ENOTDIR;
>  	if (get_user(n, name))
>  		return -EFAULT;
> +	if (!n)
> +		return -ENOTDIR;
>  	for ( ; table->ctl_name || table->procname; table++) {
> -		if (!table->ctl_name)
> -			continue;
>  		if (n == table->ctl_name) {
>  			int error;
>  			if (table->child) {

I don't like this. For one, it destroy some symmetry in sysctl table
walking code, where sysctl(2) code checks for valid ->ctl_name, and proc
code checks for valid ->procname and both have same for loop. For two,
nobody uses sysctl(2), sysctl aren't big, so this optimization is
unneeded.

