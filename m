Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbXJaK4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbXJaK4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXJaK4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:56:05 -0400
Received: from nic2.axis.se ([193.13.178.10]:55545 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbXJaK4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:56:04 -0400
Date: Wed, 31 Oct 2007 11:55:53 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mikael.starvik@axis.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/16] CRIS architecture: Correct compile errors
Message-ID: <20071031105552.GX11960@axis.com>
References: <20071030092811.GD11960@axis.com> <20071030151400.e4769e27.akpm@linux-foundation.org> <20071031104738.GW11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071031104738.GW11960@axis.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2007 at 11:47:38AM +0100, Jesper Nilsson wrote:
> On Tue, Oct 30, 2007 at 03:14:00PM -0700, Andrew Morton wrote:
> > On Tue, 30 Oct 2007 10:28:11 +0100
> > Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> > > Remove include of asm/bitops.h, not needed here, corrects compilation error
> > > (__le64 undefined).
> > [snip]
> >
> > This doesn't apply and I'm not sure that it is still needed or correct.
> > 
> > I'll drop it.
> 
> Unfortunately it is still needed, I'll resend a fresh patch
> against Linus git tree.
> 
> Compile error:
> 
>   CC      arch/cris/kernel/asm-offsets.s
> In file included from include/asm/byteorder.h:23,
>                  from include/asm-generic/bitops/le.h:5,
>                  from include/asm-generic/bitops/ext2-non-atomic.h:4,
>                  from include/asm/bitops.h:163,
>                  from include/linux/bitops.h:17,
>                  from include/asm/posix_types.h:55,
>                  from include/linux/posix_types.h:47,
>                  from include/linux/types.h:11,
>                  from include/linux/capability.h:16,
>                  from include/linux/sched.h:49,
>                  from arch/cris/kernel/asm-offsets.c:1:
> include/linux/byteorder/little_endian.h:43: parse error before "__cpu_to_le64p"
> include/linux/byteorder/little_endian.h:44: warning: return type defaults to `int'
> include/linux/byteorder/little_endian.h: In function `__cpu_to_le64p':
> include/linux/byteorder/little_endian.h:45: `__le64' undeclared (first use in this function)
> ....

Remove include of asm/bitops.h, not needed here, corrects compilation error
(__le64 undeclared).

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 posix_types.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/asm-cris/posix_types.h b/include/asm-cris/posix_types.h
index 92000d0..3a5e4c4 100644
--- a/include/asm-cris/posix_types.h
+++ b/include/asm-cris/posix_types.h
@@ -52,7 +52,6 @@ typedef struct {
 } __kernel_fsid_t;
 
 #ifdef __KERNEL__
-#include <linux/bitops.h>
 
 #undef	__FD_SET
 #define __FD_SET(fd,fdsetp) set_bit(fd, (void *)(fdsetp))



/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
