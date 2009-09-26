Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZIZUIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZIZUIo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 16:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbZIZUIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 16:08:43 -0400
Received: from [195.41.46.235] ([195.41.46.235]:59124 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751982AbZIZUIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 16:08:42 -0400
Date: Sat, 26 Sep 2009 22:08:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] linux-next: 20090926 - drop autoconf.h from DRBD driver
Message-ID: <20090926200839.GA5220@merkur.ravnborg.org>
References: <20090926152800.a6568e53.sfr@canb.auug.org.au> <20090926173143.GA5041@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926173143.GA5041@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 11:01:43PM +0530, Kamalesh Babulal wrote:
> Hi Sam,
> 
> 	next-20090926 allyesconfig build breaks on powerpc,
> 
> drivers/block/drbd/drbd_proc.c:26:28: error: linux/autoconf.h: No such file or directory
> make[3]: *** [drivers/block/drbd/drbd_proc.o] Error 1
> 
> dropping autoconf.h from drbd_proc.c helps. The cleanup patch drops the
> unneeded include autoconf.h.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

I only checked upstream - so this is no big suprise.
As there is no need to explicitly include autoconf.h this
change should be included by the drdb folks even if the
stuff I have does not hit upstream.

Can I ask you to audit the rest of -next for similar issues.
A 'git grep "autoconf\.h"' should be a qucik way to find other
spots to fix up.

Patch is:

Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam

> --
>  drivers/block/drbd/drbd_main.c     |    1 -
>  drivers/block/drbd/drbd_nl.c       |    1 -
>  drivers/block/drbd/drbd_proc.c     |    1 -
>  drivers/block/drbd/drbd_receiver.c |    1 -
>  drivers/block/drbd/drbd_req.c      |    1 -
>  drivers/block/drbd/drbd_req.h      |    1 -
>  drivers/block/drbd/drbd_worker.c   |    1 -
>  drivers/staging/cowloop/cowloop.c  |    4 ----
>  drivers/staging/iio/ring_sw.h      |    1 -
>  9 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
> index edf0b80..80273f2 100644
> --- a/drivers/block/drbd/drbd_main.c
> +++ b/drivers/block/drbd/drbd_main.c
> @@ -26,7 +26,6 @@
>  
>   */
>  
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  #include <linux/version.h>
>  #include <linux/drbd.h>
> diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
> index 1927ace..cfde310 100644
> --- a/drivers/block/drbd/drbd_nl.c
> +++ b/drivers/block/drbd/drbd_nl.c
> @@ -23,7 +23,6 @@
>  
>   */
>  
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  #include <linux/drbd.h>
>  #include <linux/in.h>
> diff --git a/drivers/block/drbd/drbd_proc.c b/drivers/block/drbd/drbd_proc.c
> index 98fcb74..bdd0b49 100644
> --- a/drivers/block/drbd/drbd_proc.c
> +++ b/drivers/block/drbd/drbd_proc.c
> @@ -23,7 +23,6 @@
>  
>   */
>  
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  
>  #include <asm/uaccess.h>
> diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
> index 63686c4..2f81821 100644
> --- a/drivers/block/drbd/drbd_receiver.c
> +++ b/drivers/block/drbd/drbd_receiver.c
> @@ -23,7 +23,6 @@
>   */
>  
>  
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  
>  #include <asm/uaccess.h>
> diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
> index 0656cf1..1aaa397 100644
> --- a/drivers/block/drbd/drbd_req.c
> +++ b/drivers/block/drbd/drbd_req.c
> @@ -23,7 +23,6 @@
>  
>   */
>  
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  
>  #include <linux/slab.h>
> diff --git a/drivers/block/drbd/drbd_req.h b/drivers/block/drbd/drbd_req.h
> index d37ab57..f22c1bc 100644
> --- a/drivers/block/drbd/drbd_req.h
> +++ b/drivers/block/drbd/drbd_req.h
> @@ -25,7 +25,6 @@
>  #ifndef _DRBD_REQ_H
>  #define _DRBD_REQ_H
>  
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  
>  #include <linux/slab.h>
> diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
> index 212e954..34a4b3e 100644
> --- a/drivers/block/drbd/drbd_worker.c
> +++ b/drivers/block/drbd/drbd_worker.c
> @@ -23,7 +23,6 @@
>  
>   */
>  
> -#include <linux/autoconf.h>
>  #include <linux/module.h>
>  #include <linux/version.h>
>  #include <linux/drbd.h>
> diff --git a/drivers/staging/cowloop/cowloop.c b/drivers/staging/cowloop/cowloop.c
> index a71c743..a21b9b4 100644
> --- a/drivers/staging/cowloop/cowloop.c
> +++ b/drivers/staging/cowloop/cowloop.c
> @@ -237,10 +237,6 @@ char revision[] = "$Revision: 3.1 $"; /* cowlo_init_module() has
>  #endif
>  
>  #include <linux/types.h>
> -#include <linux/autoconf.h>
> -#ifndef AUTOCONF_INCLUDED
> -#include <linux/config.h>
> -#endif
>  #include <linux/module.h>
>  #include <linux/version.h>
>  #include <linux/moduleparam.h>
> diff --git a/drivers/staging/iio/ring_sw.h b/drivers/staging/iio/ring_sw.h
> index ae70ee0..4b0de7c 100644
> --- a/drivers/staging/iio/ring_sw.h
> +++ b/drivers/staging/iio/ring_sw.h
> @@ -29,7 +29,6 @@
>   * driver requests - some may support multiple options */
>  
>  
> -#include <linux/autoconf.h>
>  #include "iio.h"
>  #include "ring_generic.h"
>  
> 			
> 			Kamalesh
> 
> 
