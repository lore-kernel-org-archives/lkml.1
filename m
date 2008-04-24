Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbYDXAAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbYDXAAn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 20:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYDXAAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 20:00:35 -0400
Received: from gw.goop.org ([64.81.55.164]:49748 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYDXAAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 20:00:35 -0400
Message-ID: <480FCD9F.3020403@goop.org>
Date: Wed, 23 Apr 2008 17:00:31 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Isaku Yamahata <yamahata@valinux.co.jp>
CC: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com
Subject: Re: [PATCH 1/3] xen: Move manage.c to drivers/xen for ia64/xen support.
References: <12088476062604-git-send-email-yamahata@valinux.co.jp> <12088476061989-git-send-email-yamahata@valinux.co.jp>
In-Reply-To: <12088476061989-git-send-email-yamahata@valinux.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Isaku Yamahata wrote:
> move arch/x86/xen/manage.c under drivers/xen/to share codes
> with x86 and ia64.
> ia64/xen also uses manage.c
>   

Hm, I've got patches to add suspend/resume to manage.c.  I guess they're 
going to be at least partially arch-specific.  Well, no problem to split 
those out.

    J

> Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
> ---
>  arch/x86/xen/Makefile              |    2 +-
>  drivers/xen/Makefile               |    2 +-
>  {arch/x86 => drivers}/xen/manage.c |    0 
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename {arch/x86 => drivers}/xen/manage.c (100%)
>
> diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
> index 3d8df98..40b119b 100644
> --- a/arch/x86/xen/Makefile
> +++ b/arch/x86/xen/Makefile
> @@ -1,4 +1,4 @@
>  obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
> -			time.o manage.o xen-asm.o grant-table.o
> +			time.o xen-asm.o grant-table.o
>  
>  obj-$(CONFIG_SMP)	+= smp.o
> diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
> index 37af04f..363286c 100644
> --- a/drivers/xen/Makefile
> +++ b/drivers/xen/Makefile
> @@ -1,4 +1,4 @@
> -obj-y	+= grant-table.o features.o events.o
> +obj-y	+= grant-table.o features.o events.o manage.o
>  obj-y	+= xenbus/
>  obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
>  obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
> diff --git a/arch/x86/xen/manage.c b/drivers/xen/manage.c
> similarity index 100%
> rename from arch/x86/xen/manage.c
> rename to drivers/xen/manage.c
>   

