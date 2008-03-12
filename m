Return-Path: <linux-kernel-owner+w=401wt.eu-S1753762AbYCLNuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbYCLNuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 09:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYCLNuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 09:50:03 -0400
Received: from saeurebad.de ([85.214.36.134]:53246 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618AbYCLNt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 09:49:59 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Marcin Slusarz <marcin.slusarz@gmail.com>, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH -mm] do not check condition twice in WARN_ON_SECS
References: <20080312010933.GA2957@darkstar.te-china.tietoenator.com>
Date: Wed, 12 Mar 2008 14:47:52 +0100
In-Reply-To: <20080312010933.GA2957@darkstar.te-china.tietoenator.com> (Dave
	Young's message of "Wed, 12 Mar 2008 09:09:33 +0800")
Message-ID: <87pru0oxyv.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Dave Young <hidave.darkstar@gmail.com> writes:

> Don't check condition twice, change WARN_ON(condition) to WARN_ON(1)
> Thanks Marcin Slusarz <marcin.slusarz@gmail.com> for pointing out
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> ---
> include/asm-generic/bug.h |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff -upr linux/include/asm-generic/bug.h linux.new/include/asm-generic/bug.h
> --- linux/include/asm-generic/bug.h	2008-03-12 08:45:08.000000000 +0800
> +++ linux.new/include/asm-generic/bug.h	2008-03-12 09:04:07.000000000 +0800
> @@ -80,7 +80,8 @@ extern void warn_on_slowpath(const char 
>  	int __ret_warn_on = !!(condition);			\
>  	if (unlikely(__ret_warn_on))				\
>  		if (__ratelimit(secs * HZ, 1))			\
> -			WARN_ON(condition);			\
> +			WARN_ON(1);				\
> +	unlikely(__ret_warn_on);				\
>  })

What's wrong with:

#define WARN_ON_SECS(condition, secs) \
	WARN_ON(condition && __ratelimit(secs * HZ, 1))

?

	Hannes
