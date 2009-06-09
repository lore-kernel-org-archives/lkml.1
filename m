Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbZFIRjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbZFIRjo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 13:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZFIRjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 13:39:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:49699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbZFIRjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 13:39:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 16/27] score: create head files scatterlist.h scoreregs.h sections.h segment.h sembuf.h setup.h shmbuf.h shmparam.h sigcontext.h siginfo.h signal.h socket.h sockios.h statfs.h stat.h string.h swab.h syscalls.h system.h
Date: Tue, 9 Jun 2009 19:39:01 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OF6E98041E.B5C6A199-ON482575D0.0023E412-482575D0.00245A53@sunplusct.com>
In-Reply-To: <OF6E98041E.B5C6A199-ON482575D0.0023E412-482575D0.00245A53@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091939.01217.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/hRG1SRBcOzlG5EulinxhdlCwi02ZcPy4IKfG
 y5UP+RTZtiH7hrfmKj4txpqjUpIFf5AgDvZxUvdBrRb1kofUwq
 LvoQqJ+o9KYL3prRYtve23MYxJfWMVv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:

> --- /dev/null
> +++ b/arch/score/include/asm/segment.h
> @@ -0,0 +1,21 @@
> +#ifndef _ASM_SCORE_SEGMENT_H
> +#define _ASM_SCORE_SEGMENT_H
> +
> +#ifndef __ASSEMBLY__
> +
> +typedef struct {
> +       unsigned long seg;
> +} mm_segment_t;
> +
> +#define KERNEL_DS      ((mm_segment_t){0})
> +#define USER_DS        KERNEL_DS
> +
> +# define get_ds()      (KERNEL_DS)
> +# define get_fs()      (current_thread_info()->addr_limit)
> +# define set_fs(x)     \
> +       do { current_thread_info()->addr_limit = (x); } while (0)
> +
> +# define segment_eq(a, b)      ((a).seg == (b).seg)
> +
> +# endif /* __ASSEMBLY__ */
> +#endif /* _ASM_SCORE_SEGMENT_H */

When I discussed these definitions with Michal Simek, we concluded
that they do not actually belong into segment.h. I added them to
asm-generic/uaccess.h, so if you can use that, you get them for free
and can have an empty segment.h file.

	Arnd <><
