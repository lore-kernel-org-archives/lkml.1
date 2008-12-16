Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbYLPAh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbYLPAh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 19:37:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755053AbYLPAhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 19:37:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45997 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754632AbYLPAhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 19:37:15 -0500
Date: Mon, 15 Dec 2008 16:36:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: penguin-kernel@i-love.sakura.ne.jp, linux-kernel@vger.kernel.org
Subject: Re: [mmotm-2008-12-11-15-20] __unsafe() not defined.
Message-Id: <20081215163658.3a105aa5.akpm@linux-foundation.org>
In-Reply-To: <20081212144040.GC2402@hmsreliant.think-freely.org>
References: <200812120209.mBC29Qx5064845@www262.sakura.ne.jp>
	<20081211181733.7031df32.akpm@linux-foundation.org>
	<20081212144040.GC2402@hmsreliant.think-freely.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Dec 2008 09:40:41 -0500
Neil Horman <nhorman@tuxdriver.com> wrote:

> On Thu, Dec 11, 2008 at 06:17:33PM -0800, Andrew Morton wrote:
> > On Fri, 12 Dec 2008 11:09:26 +0900 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > 
> > > I got this compilation error using gcc (GCC) 3.3.5 (Debian 1:3.3.5-13).
> > > 
> > >   drivers/pci/hotplug/ibmphp_core.c: In function `ibmphp_init':
> > >   drivers/pci/hotplug/ibmphp_core.c:1409: error: implicit declaration of function `__unsafe'
> > >   make[3]: *** [drivers/pci/hotplug/ibmphp_core.o] Error 1
> > >   make[2]: *** [drivers/pci/hotplug] Error 2
> > >   make[1]: *** [drivers/pci] Error 2
> > >   make: *** [drivers] Error 2
> > > 
> > > "grep -Fr __unsafe ." shows only one line.
> > > 
> > >   ./drivers/pci/hotplug/ibmphp_core.c:    __unsafe(THIS_MODULE);
> > > 
> > > Where is __unsafe defined?
> > > 
> > 
> > hm, I wonder what that was all about.
> > 
> > I'll drop ibmphp-fix-module-ref-count-underflow.patch, thanks.

It is fortunate indeed that I mentioned the old patch name in my email.

> 
> 
> Apologies, I was working with an old tree.  __unsafe has been deprecated.  To
> accomplish the functionality of unsafe, we simply need to not register an exit
> routine, as per Adrian Bunks commit when __unsafe was removed.  I'm leaving the
> ibmphp_exit function in place though, just in case the author decides later that
> it is in fact safe to remove.
> 
> New patch attached.
> 
> Regards
> Neil
> 
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> 
> 
>  ibmphp_core.c |    5 -----
>  1 file changed, 5 deletions(-)

Because otherwise it would have been rather difficult for me to locate
the changelog.

Oh dear, the original changelog is now wrong.

> 
> diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
> index c892daa..633e743 100644
> --- a/drivers/pci/hotplug/ibmphp_core.c
> +++ b/drivers/pci/hotplug/ibmphp_core.c
> @@ -1402,10 +1402,6 @@ static int __init ibmphp_init(void)
>  		goto error;
>  	}
>  
> -	/* lock ourselves into memory with a module 
> -	 * count of -1 so that no one can unload us. */
> -	module_put(THIS_MODULE);
> -
>  exit:
>  	return rc;
>  
> @@ -1423,4 +1419,3 @@ static void __exit ibmphp_exit(void)
>  }
>  
>  module_init(ibmphp_init);
> -module_exit(ibmphp_exit);

So I won't be applying this.

