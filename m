Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbYJTXxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbYJTXxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYJTXxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:53:00 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25606 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYJTXxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:53:00 -0400
Date: Mon, 20 Oct 2008 17:52:58 -0600
From: Alex Chiang <achiang@hp.com>
To: ebiederm@xmission.com, oomichi@mxs.nes.nec.co.jp,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       tony.luck@intel.com
Subject: Re: [PATCH] declare vmlist to fix ia64 build breakage in kexec core
Message-ID: <20081020235258.GH15771@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>, ebiederm@xmission.com,
	oomichi@mxs.nes.nec.co.jp, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, tony.luck@intel.com
References: <20081020233438.GG15771@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020233438.GG15771@ldl.fc.hp.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oh whoops, I see that Tony Luck already sent a patch for this
directly to Linus.

[Sorry for the noise, but I didn't realize this until I decided
to browse through my lkml folder, as Tony's patch hasn't been
pushed out yet.]

/ac

* Alex Chiang <achiang@hp.com>:
> Commit acd99dbf54020f5c80b9aa2f2ea86f43cb285b02 (kdump: add
> vmlist.addr to vmcoreinfo for x86 vmalloc translation) broke the
> ia64 build in this fashion:
> 
> kernel/kexec.c: In function `crash_save_vmcoreinfo_init':
> kernel/kexec.c:1374: error: `vmlist' undeclared (first use in this function)
> kernel/kexec.c:1374: error: (Each undeclared identifier is reported only once
> kernel/kexec.c:1374: error: for each function it appears in.)
> kernel/kexec.c:1410: error: dereferencing pointer to incomplete type
> make[1]: *** [kernel/kexec.o] Error 1
> 
> Adding the proper include fixes the build.
> 
> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 777ac45..ac0fde7 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -30,6 +30,7 @@
>  #include <linux/pm.h>
>  #include <linux/cpu.h>
>  #include <linux/console.h>
> +#include <linux/vmalloc.h>
>  
>  #include <asm/page.h>
>  #include <asm/uaccess.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
