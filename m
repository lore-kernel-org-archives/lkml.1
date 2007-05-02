Return-Path: <linux-kernel-owner+w=401wt.eu-S1766771AbXEBTg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766771AbXEBTg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766768AbXEBTg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:36:27 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:41983 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766771AbXEBTgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:36:09 -0400
Date: Wed, 2 May 2007 21:37:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Green <andy@warmcat.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scripts/basic/fixdep segfault on pathological string-o-death
Message-ID: <20070502193702.GA9044@uranus.ravnborg.org>
References: <46387AB2.1090800@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46387AB2.1090800@warmcat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 12:49:06PM +0100, Andy Green wrote:
> build scripts: fixdep blows segfault on string CONFIG_MODULE seen
> 
> The string "CONFIG_MODULE" appearing anywhere in a source file causes
> fixdep to segfault.  This string appeared in the wild in the current
> mISDN sources (I think they meant CONFIG_MODULES).  But it shouldn't
> segfault (esp as CONFIG_MODULE appeared in a quoted string).
> 
> Signed-off-by: Andy Green <andy@warmcat.com>

Applied and forwarded to stable@kernel.org.

Thanks,
	Sam

> ---
>  scripts/basic/fixdep.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: 2.6.21-1.3116.fc7-i686/scripts/basic/fixdep.c
> ===================================================================
> --- 2.6.21-1.3116.fc7-i686.orig/scripts/basic/fixdep.c
> +++ 2.6.21-1.3116.fc7-i686/scripts/basic/fixdep.c
> @@ -249,6 +249,8 @@ void parse_config_file(char *map, size_t
>  	found:
>  		if (!memcmp(q - 7, "_MODULE", 7))
>  			q -= 7;
> +		if( (q-p-7) < 0 )
> +			continue;
>  		use_config(p+7, q-p-7);
>  	}
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
