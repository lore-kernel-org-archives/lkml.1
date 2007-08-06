Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbXHFHet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbXHFHet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 03:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbXHFHem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 03:34:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59384
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755294AbXHFHel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 03:34:41 -0400
Date: Mon, 06 Aug 2007 00:34:41 -0700 (PDT)
Message-Id: <20070806.003441.41635922.davem@davemloft.net>
To: jdi@l4x.org
Cc: linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       wli@holomorphy.com, chris@zankel.net, rth@twiddle.net
Subject: Re: 2.6.23-rc2 cross compile regressions (alpha,sparc,xtensa)
From: David Miller <davem@davemloft.net>
In-Reply-To: <46B6CE6B.7010808@l4x.org>
References: <46B6CE6B.7010808@l4x.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Dittmer <jdi@l4x.org>
Date: Mon, 06 Aug 2007 09:31:55 +0200

> sparc/defconfig:
>   CC      init/main.o
> In file included from include/linux/proc_fs.h:5,
>                  from init/main.c:14:
> include/linux/fs.h:848: warning: `struct flock' declared inside parameter list
> include/linux/fs.h:848: warning: its scope is only this definition or declaration, which is probably not what you want
> include/linux/fs.h:850: warning: `struct flock' declared inside parameter list
> include/linux/fs.h:853: warning: `struct flock64' declared inside parameter list
> include/linux/fs.h:855: warning: `struct flock64' declared inside parameter list
> init/main.c: In function `init_post':
> init/main.c:782: error: `O_RDWR' undeclared (first use in this function)
> init/main.c:782: error: (Each undeclared identifier is reported only once
> init/main.c:782: error: for each function it appears in.)
> make[2]: *** [init/main.o] Error 1
> make[1]: *** [init] Error 2
> make: *** [_all] Error 2

Fix below has already been submmited.

BTW, you'll have much better luck with reports like this if you
direct them to the platform specific mailing list, which would
be sparclinux@vger.kernel.org in this case.

commit c8154c8a9aaf548ad91e413da8b319858e37bc52
Author: Mark Fortescue <mark@mtfhpc.demon.co.uk>
Date:   Sat Aug 4 21:17:18 2007 -0700

    [SPARC32]: Fix build.
    
    Correct incorrect removal of asm-generic/fcntl.h from asm-sparc/fcntl.h by
    commit 6ba60d2195cd65d72eaf7ce3903a707c5bf20c7b.
    
    Signed-off-by: Mark Fortescue <mark@mtfhpc.demon.co.uk>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/asm-sparc/fcntl.h b/include/asm-sparc/fcntl.h
index 7bbdfc7..5ec5463 100644
--- a/include/asm-sparc/fcntl.h
+++ b/include/asm-sparc/fcntl.h
@@ -32,5 +32,6 @@
 #define __ARCH_FLOCK_PAD	short __unused;
 #define __ARCH_FLOCK64_PAD	short __unused;
 
+#include <asm-generic/fcntl.h>
 
 #endif
