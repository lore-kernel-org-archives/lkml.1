Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166AbYCKTVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166AbYCKTVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYCKTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:21:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:54515 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbYCKTVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TArsjsD+aAmX1s4Rv2lWoJgjHLVp59vYPCBea75S/sXack/QQ++6Pkw1K7PaLVSbwGTdCNZP4bh5Ta80g684YgkRuvJHhu8IV7wE7typv5ll2WAF9JUt4Z1yW9GgJuFSq539q/rX8+iZ3VtcEkKlpy2LgqX5FIjWopkZEV9wpq8=
Date: Tue, 11 Mar 2008 20:20:37 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] [2/3] add WARN_ON_SECS macro
Message-ID: <20080311192031.GA7178@joi>
References: <20080310063437.GB6745@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080310063437.GB6745@darkstar.te-china.tietoenator.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2008 at 02:34:37PM +0800, Dave Young wrote:
> Add WARN_ON_SECS macro for some serious case which need repeat the
> warnings, but with some ratelimit.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> 
> ---
> include/asm-generic/bug.h |    8 ++++++++
> 1 file changed, 8 insertions(+)
> 
> diff -upr linux/include/asm-generic/bug.h linux.new/include/asm-generic/bug.h
> --- linux/include/asm-generic/bug.h	2008-03-10 13:27:03.000000000 +0800
> +++ linux.new/include/asm-generic/bug.h	2008-03-10 13:27:14.000000000 +0800
> @@ -3,6 +3,7 @@
>  
>  #include <linux/compiler.h>
>  
> +
>  #ifdef CONFIG_BUG
>  
>  #ifdef CONFIG_GENERIC_BUG
> @@ -75,6 +76,13 @@ extern void warn_on_slowpath(const char 
>  	unlikely(__ret_warn_once);				\
>  })
>  
> +#define WARN_ON_SECS(condition, secs) ({			\
> +	int __ret_warn_on = !!(condition);			\
> +	if (unlikely(__ret_warn_on))				\
> +		if (__ratelimit(secs * HZ, 1))			\
> +			WARN_ON(condition);			\
> +})
> +
>  #ifdef CONFIG_SMP
>  # define WARN_ON_SMP(x)			WARN_ON(x)
>  #else

Do you really want to check the condition twice?

Marcin
