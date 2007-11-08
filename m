Return-Path: <linux-kernel-owner+w=401wt.eu-S1760253AbXKHDWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760253AbXKHDWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 22:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbXKHDWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 22:22:43 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36568 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbXKHDWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 22:22:43 -0500
Date: Wed, 7 Nov 2007 19:22:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysctl: Check length at deprecated_sysctl_warning.
Message-Id: <20071107192211.c1c22e97.akpm@linux-foundation.org>
In-Reply-To: <200711080257.lA82vQfA015942@www262.sakura.ne.jp>
References: <200711080257.lA82vQfA015942@www262.sakura.ne.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 08 Nov 2007 11:57:26 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> Original patch assumed args->nlen < CTL_MAXNAME, but it can be false.
> 
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> 
> --- linux-2.6.22-rc2.orig/kernel/sysctl.c	2007-11-08 10:38:17.000000000 +0900
> +++ linux-2.6.22-rc2/kernel/sysctl.c	2007-11-08 11:24:27.000000000 +0900
> @@ -2609,6 +2609,10 @@ static int deprecated_sysctl_warning(str
>  	int name[CTL_MAXNAME];
>  	int i;
>  
> +	/* Check args->nlen. */
> +	if (args->nlen > CTL_MAXNAME)
> +		return -EFAULT;
> +
>  	/* Read in the sysctl name for better debug message logging */
>  	for (i = 0; i < args->nlen; i++)
>  		if (get_user(name[i], args->name + i))

Well that would have been a nice roothole for someone.  Thanks.
