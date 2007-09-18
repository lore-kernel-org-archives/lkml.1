Return-Path: <linux-kernel-owner+w=401wt.eu-S1758969AbXIRUOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969AbXIRUOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 16:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755104AbXIRUOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 16:14:08 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:57300 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbXIRUOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 16:14:06 -0400
Date: Tue, 18 Sep 2007 22:15:26 +0200
From: Andreas Herrmann <aherrman@arcor.de>
To: roel <12o3l@tiscali.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Message-ID: <20070918201526.GB5279@devil>
References: <20070918080537.GA14882@devil> <46F01E9F.3010307@tiscali.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F01E9F.3010307@tiscali.nl>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 08:53:19PM +0200, roel wrote:
> Andreas Herrmann wrote:
> > Fix compile error if !CONFIG_SYSCTL:
> > 
> >     ...
> >   LD      .tmp_vmlinux1
> > net/built-in.o: In function `init_p9':
> > net/9p/mod.c:59: undefined reference to `p9_sysctl_register'
> > net/built-in.o: In function `exit_p9':
> > net/9p/mod.c:75: undefined reference to `p9_sysctl_unregister'
> > make: *** [.tmp_vmlinux1] Error 1
> >     ...
> >  
> isn't it nicer to do something like this instead?

No.

> diff --git a/net/9p/sysctl.c b/net/9p/sysctl.c
> index 8b61027..e199865 100644
> --- a/net/9p/sysctl.c
> +++ b/net/9p/sysctl.c
> @@ -68,14 +68,17 @@ static struct ctl_table_header *p9_table_header;
>  
>  int __init p9_sysctl_register(void)
>  {
> +#ifdef CONFIG_SYSCTL
>  	p9_table_header = register_sysctl_table(p9_ctl_table);
>  	if (!p9_table_header)
>  		return -ENOMEM;
> -
> +#endif
>  	return 0;
>  }
>  
>  void __exit p9_sysctl_unregister(void)
>  {
> +#ifdef CONFIG_SYSCTL
>  	 unregister_sysctl_table(p9_table_header);
> +#endif
>  }

The problem is not that (un)register_sysctl_table were not defined
if !CONFIG_SYSCTL. There are stubs in kernel/sysctl.c for this case.
I.e. your patch is superfluous.

The point is, 9p/sysctl.c is compiled iff CONFIG_SYSCTL is set.
See net/9p/Makefile ...


Regards,

Andreas

