Return-Path: <linux-kernel-owner+w=401wt.eu-S1757171AbZFIRqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171AbZFIRqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZFIRqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:46:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:58775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbZFIRqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:46:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 18/27] score: create head files uaccess.h unaligned.h unistd.h user.h
Date: Tue, 9 Jun 2009 19:46:10 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF596C037E.9CF83913-ON482575D0.0024055D-482575D0.002476E7@sunplusct.com>
In-Reply-To: <OF596C037E.9CF83913-ON482575D0.0024055D-482575D0.002476E7@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091946.10195.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+v54J7uDtU6gFW6IxMHOXEWa/ndCMt4y+Waqq
 zADOGUuxldHbNDil5ZFe8a7TjBzSFi/ZNs/X6ymEIrhas4vtOT
 8emzk4RxhRFB0EPZIUs6A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:

> diff --git a/arch/score/include/asm/unaligned.h 
> b/arch/score/include/asm/unaligned.h
> new file mode 100644
> index 0000000..4b8fec0
> --- /dev/null
> +++ b/arch/score/include/asm/unaligned.h
> @@ -0,0 +1,11 @@
> +#ifndef _ASM_SCORE_UNALIGNED_H
> +#define _ASM_SCORE_UNALIGNED_H
> +
> +#include <linux/unaligned/le_struct.h>
> +#include <linux/unaligned/be_byteshift.h>
> +#include <linux/unaligned/generic.h>
> +
> +#define get_unaligned  __get_unaligned_le
> +#define put_unaligned  __put_unaligned_le
> +
> +#endif /* _ASM_SCORE_UNALIGNED_H */

Any reason not to use the asm-generic version of this file?
If it didn't work, that is probably a bug in my code, not
yours, but they really look compatible.

> diff --git a/arch/score/include/asm/unistd.h 
> b/arch/score/include/asm/unistd.h
> new file mode 100644
> index 0000000..0cbfef8
> --- /dev/null
> +++ b/arch/score/include/asm/unistd.h
> @@ -0,0 +1,12 @@
> +#ifndef _ASM_SCORE_UNISTD_H
> +#define _ASM_SCORE_UNISTD_H
> +
> +#define __ARCH_HAVE_MMU
> +#define __ARCH_WANT_SYSCALL_NO_AT
> +#define __ARCH_WANT_SYSCALL_NO_FLAGS
> +#define __ARCH_WANT_SYSCALL_OFF_T
> +#define __ARCH_WANT_SYSCALL_DEPRECATED
> +
> +#include <asm-generic/unistd.h>

I realize that this is the code I added to microblaze in my tree.
However, the four __ARCH_WANT_SYSCALL_* definitions are really
only meant as a transitional helper to get your code ported
from the older ABI. They should be removed from your file in 
order to get the short system call list. Have you tried this?

In order to get there, you probably need to add a lot of wrappers
to libc along the lines of

int unlink(const char *pathname)
{
	return unlinkat(AT_FDCWD, pathname, 0);
}

	Arnd <><
