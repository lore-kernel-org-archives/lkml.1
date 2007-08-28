Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbXH1Um1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbXH1Um1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXH1UmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 16:42:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:52777 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbXH1UmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 16:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=tPlgXDc5j10KFw7QKESJxyfjPUxbbq7R+l3beDWc/ai3NdePQhzh+EetWRi4VueBCWDZ/zxqIimfUHD9RHjTYG0xMIGf8/oPrLsC54u2ghkh/fqDRj9kQ+LzJyG02nxFSRoNO1h6iR2GDIjg37XKpXaXmMmRMOxfgpOM+eyZwhU=
Date: Wed, 29 Aug 2007 00:42:03 +0400
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trivial@kernel.org
Subject: Re: [PATCH] Add documentation to some preprocessor directives in init/*.c.
Message-ID: <20070828204203.GA3258@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0708280153050.28330@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708280153050.28330@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 01:56:24AM -0400, Robert P. J. Day wrote:
> Add some documentation to potentially confusing preprocessor
> directives in some source files in the init/ directory to show their
> proper association and nesting.

> --- a/init/calibrate.c
> +++ b/init/calibrate.c
> @@ -101,7 +101,7 @@ static unsigned long __devinit calibrate_delay_direct(void)
>  	       "estimate for loops_per_jiffy.\nProbably due to long platform interrupts. Consider using \"lpj=\" boot option.\n");
>  	return 0;
>  }
> -#else
> +#else /* !ARCH_HAS_READ_CURRENT_TIMER */
>  static unsigned long __devinit calibrate_delay_direct(void) {return 0;}
>  #endif

I'm sorry, but this is not useful. You're adding comments and compiler
ignores comments. So, one can't rely on such comments being accurate and
will go to start of section for recheck anyway.
