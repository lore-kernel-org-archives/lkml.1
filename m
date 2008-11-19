Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbYKSGd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbYKSGd5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 01:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbYKSGdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 01:33:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbYKSGds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 01:33:48 -0500
Date: Tue, 18 Nov 2008 22:33:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <cooloney@kernel.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] asm/generic: fix bug - kernel fails to build when
 enable some common audit code on Blackfin
Message-Id: <20081118223308.396ec63b.akpm@linux-foundation.org>
In-Reply-To: <1226991829-30641-1-git-send-email-cooloney@kernel.org>
References: <1226991829-30641-1-git-send-email-cooloney@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008 15:03:49 +0800 Bryan Wu <cooloney@kernel.org> wrote:

> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> If you enable some common audit code, the kernel fails to build.
> 
> In file included from lib/audit.c:17:
> include/asm-generic/audit_write.h:3: error: '__NR_swapon' undeclared here (not in a function)
> make[1]: *** [lib/audit.o] Error 1
> make: *** [lib] Error 2
> 
> So do not use __NR_swapon if it isnt defined for a port.
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  include/asm-generic/audit_write.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/include/asm-generic/audit_write.h b/include/asm-generic/audit_write.h
> index f10d367..c5f1c2c 100644
> --- a/include/asm-generic/audit_write.h
> +++ b/include/asm-generic/audit_write.h
> @@ -1,6 +1,8 @@
>  #include <asm-generic/audit_dir_write.h>
>  __NR_acct,
> +#ifdef __NR_swapon
>  __NR_swapon,
> +#endif
>  __NR_quotactl,
>  __NR_truncate,
>  #ifdef __NR_truncate64

hrm.

Should blackfin define __NR_swapon instead?  afacit
include/asm/unistd.h is an exported-to-userspace header, so the
architecture should export __NR_swapon to prevent userspace build
failures?


