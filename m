Return-Path: <linux-kernel-owner+w=401wt.eu-S1762567AbYB1AcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762567AbYB1AcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:32:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbYB1Ab5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:31:57 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757408AbYB1Ab4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:31:56 -0500
Date: Wed, 27 Feb 2008 16:31:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andres Salomon <dilinger@queued.net>
Cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net, info-linux@geode.amd.com,
       jordan.crouse@amd.com, dwmw2@infradead.org
Subject: Re: [PATCH 1/4] gxfb: Replace FBSIZE config option with a kernel
 argument
Message-Id: <20080227163105.e1b96023.akpm@linux-foundation.org>
In-Reply-To: <20080223011045.48e6cb8e@ephemeral>
References: <20080223011045.48e6cb8e@ephemeral>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 01:10:45 -0500
Andres Salomon <dilinger@queued.net> wrote:

> @@ -425,7 +424,10 @@ static int __init gxfb_setup(char *options)
>  		if (!*opt)
>  			continue;
>  
> -		mode_option = opt;
> +		if (!strncmp(opt, "fbsize:", 7))
> +			fbsize = simple_strtoul(opt+7, NULL, 0);
> +		else
> +			mode_option = opt;
>  	}

The above shouldn't be necessary.

And it should have been documented in Documentation/kernel-parameters.txt.

And "fbsize=N" would be a lot more conventional than "fbsize:N"

I suspect that the formulation you have here will not permit "fbsize:128k",
whereas "fbsize=128k" or "gxfb.fbsize=128k" should work.  Needs checking.

>  	return 0;
> @@ -456,5 +458,8 @@ module_exit(gxfb_cleanup);
>  module_param(mode_option, charp, 0);
>  MODULE_PARM_DESC(mode_option, "video mode (<x>x<y>[-<bpp>][@<refr>])");
>  
> +module_param(fbsize, int, 0);
> +MODULE_PARM_DESC(fbsize, "video memory size");
> +

Because the module_param() already makes fbsize available on the kernel
boot command line via gxfb.fbsize=42 (or something similar).


