Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbYJPWlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbYJPWlW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbYJPWlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:41:12 -0400
Received: from mga12.intel.com ([143.182.124.36]:13428 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800AbYJPWlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:41:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,427,1220252400"; 
   d="scan'208";a="61082479"
Message-ID: <48F7C2FE.8070907@linux.intel.com>
Date: Thu, 16 Oct 2008 18:41:02 -0400
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, neilb@suse.de,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [2.6 patch] init/do_mounts_md.c must #include <linux/delay.h>
References: <20081016202921.GD22554@cs181140183.pp.htv.fi>
In-Reply-To: <20081016202921.GD22554@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sigh; header "cleanups" crossing ;(


Adrian Bunk wrote:
> This patch fixes the following compile error caused by
> commit 589f800bb12c5cd6c9167bbf9bf3cb70cd8e422c
> (fastboot: make the raid autodetect code wait for all devices to init):
> 
> <--  snip  -->
> 
> ...
>   CC      init/do_mounts_md.o
> init/do_mounts_md.c: In function 'autodetect_raid':
> init/do_mounts_md.c:285: error: implicit declaration of function 'msleep'
> make[2]: *** [init/do_mounts_md.o] Error 1
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> diff --git a/init/do_mounts_md.c b/init/do_mounts_md.c
> index 48b3fad..4c87ee1 100644
> --- a/init/do_mounts_md.c
> +++ b/init/do_mounts_md.c
> @@ -1,5 +1,6 @@
>  
>  #include <linux/raid/md.h>
> +#include <linux/delay.h>
>  
>  #include "do_mounts.h"
>  
> 

