Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbYFHO3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbYFHO3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 10:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbYFHO3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 10:29:40 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:48271 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbYFHO3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 10:29:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BUeeG+AcaVNL58pJEZurd9755q3/WeisOAfOEDH51bIBT6lWmWOkJB8hLW0O+xPFdz
         6ESzPkcqZ04twVcFhaC/DCoj62v09bcLt4NGDtXWvA4GByoaKxXL+/gw3oJgy7rVSTyI
         /DXP/P4QFtRKGsOvueqnvwwQe+eaYcxrunp0c=
Date: Sun, 8 Jun 2008 22:26:06 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
       anderson@redhat.com
Subject: Re: [patch 2/3] Add flags parameter to reserve_bootmem_generic()
Message-ID: <20080608142606.GE2487@hacking>
References: <20080608134628.757299158@halley.suse.de> <20080608134629.743220278@halley.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080608134629.743220278@halley.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 03:46:30PM +0200, Bernhard Walle wrote:
>This patch adds a 'flags' parameter to reserve_bootmem_generic() like it
>already has been added in reserve_bootmem() with commit
>72a7fe3967dbf86cb34e24fbf1d957fe24d2f246.
>
>It also changes all users to use BOOTMEM_DEFAULT, which doesn't effectively
>change the behaviour. Since the change is x86-specific, I don't think it's
>necessary to add a new API for migration. There are only 4 users of that
>function.
>
>The change is necessary for the next patch, using reserve_bootmem_generic()
>for crashkernel reservation.
>
>
>Signed-off-by: Bernhard Walle <bwalle@suse.de>
>
>---
> arch/x86/kernel/e820_64.c |    3 ++-
> arch/x86/kernel/efi_64.c  |    3 ++-
> arch/x86/kernel/mpparse.c |    5 +++--
> arch/x86/mm/init_64.c     |   17 ++++++++++++-----
> include/asm-x86/proto.h   |    2 +-
> 5 files changed, 20 insertions(+), 10 deletions(-)
>
>--- a/arch/x86/kernel/e820_64.c
>+++ b/arch/x86/kernel/e820_64.c
>@@ -118,7 +118,8 @@ void __init early_res_to_bootmem(unsigne
> 			continue;
> 		printk(KERN_INFO "  early res: %d [%lx-%lx] %s\n", i,
> 			final_start, final_end - 1, r->name);
>-		reserve_bootmem_generic(final_start, final_end - final_start);
>+		reserve_bootmem_generic(final_start, final_end - final_start,
>+			BOOTMEM_DEFAULT);
> 	}
> }
> 
>--- a/arch/x86/kernel/efi_64.c
>+++ b/arch/x86/kernel/efi_64.c
>@@ -100,7 +100,8 @@ void __init efi_call_phys_epilog(void)
> void __init efi_reserve_bootmem(void)
> {
> 	reserve_bootmem_generic((unsigned long)memmap.phys_map,
>-				memmap.nr_map * memmap.desc_size);
>+				memmap.nr_map * memmap.desc_size,
>+				BOOTMEM_DEFAULT);
> }

Just one comment.

Since 'reserve_bootmem_generic' is changed from 'void' to 'int',
we should check its return value for failure when possible, right?


-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
