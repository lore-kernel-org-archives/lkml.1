Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZFTVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZFTVPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 17:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753485AbZFTVOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 17:14:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:53906 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbZFTVOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 17:14:54 -0400
Subject: Re: [PATCH -tip RESEND] x86: asm/unistd.h common for kernel and
 user space
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1245530719.2459.2.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
	 <1245346986.2481.10.camel@ht.satnam>  <1245347082.2481.12.camel@ht.satnam>
	 <1245347118.2481.13.camel@ht.satnam>  <1245530719.2459.2.camel@ht.satnam>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 02:45:25 +0530
Message-Id: <1245532525.2459.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 02:15 +0530, Jaswinder Singh Rajput wrote:
> Make asm/unistd.h common for kernel and user space.
> 
> Also defined _ASM_X86_UNISTD_H
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/include/asm/unistd.h |   15 ++++++---------
>  1 files changed, 6 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
> index 2a58ed3..0de8cb3 100644
> --- a/arch/x86/include/asm/unistd.h
> +++ b/arch/x86/include/asm/unistd.h
> @@ -1,13 +1,10 @@
> -#ifdef __KERNEL__
> -# ifdef CONFIG_X86_32
> +#ifndef _ASM_X86_UNISTD_H
> +#define _ASM_X86_UNISTD_H
> +
> +# if defined(CONFIG_X86_32) || defined(__i386__)
>  #  include "unistd_32.h"
>  # else
>  #  include "unistd_64.h"
>  # endif
> -#else
> -# ifdef __i386__
> -#  include "unistd_32.h"
> -# else
> -#  include "unistd_64.h"
> -# endif
> -#endif
> +
> +#endif /* _ASM_X86_UNISTD_H */

Can we use this :

[PATCH -tip] x86: asm/unistd.h common for kernel and user space

Make asm/unistd.h common for kernel and user space.

Also defined _ASM_X86_UNISTD_H

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/unistd.h |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/unistd.h b/arch/x86/include/asm/unistd.h
index 2a58ed3..3e8182e 100644
--- a/arch/x86/include/asm/unistd.h
+++ b/arch/x86/include/asm/unistd.h
@@ -1,13 +1,10 @@
-#ifdef __KERNEL__
-# ifdef CONFIG_X86_32
-#  include "unistd_32.h"
-# else
-#  include "unistd_64.h"
-# endif
+#ifndef _ASM_X86_UNISTD_H
+#define _ASM_X86_UNISTD_H
+
+#ifdef __x86_64__
+# include "unistd_64.h"
 #else
-# ifdef __i386__
-#  include "unistd_32.h"
-# else
-#  include "unistd_64.h"
-# endif
+# include "unistd_32.h"
 #endif
+
+#endif /* _ASM_X86_UNISTD_H */
-- 
1.6.0.6



