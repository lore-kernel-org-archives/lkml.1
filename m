Return-Path: <linux-kernel-owner+w=401wt.eu-S1757584AbZFIQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584AbZFIQvj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbZFIQva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:51:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZFIQv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:51:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 04/27] score: create head files bitops.h bitsperlong.h bug.h bugs.h byteorder.h
Date: Tue, 9 Jun 2009 18:50:57 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org
References: <OFBB948A5B.D38E1AE1-ON482575D0.00233280-482575D0.0023A73C@sunplusct.com>
In-Reply-To: <OFBB948A5B.D38E1AE1-ON482575D0.00233280-482575D0.0023A73C@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906091850.58266.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18LCZPxcPRJ2ZVi/IEU7UniQX31L5I123kH0Bk
 H9dvZabH7AS/CnR2YK9T+4VdtVQXETU0MZslo3TQtEV/8ldXEr
 MVHc6Uj2cd8RaimlqU9ig==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 June 2009, liqin.chen@sunplusct.com wrote:

> diff --git a/arch/score/include/asm/bitops.h 
> b/arch/score/include/asm/bitops.h
> new file mode 100644
> index 0000000..2763b05
> --- /dev/null
> +++ b/arch/score/include/asm/bitops.h
> @@ -0,0 +1,16 @@
> +#ifndef _ASM_SCORE_BITOPS_H
> +#define _ASM_SCORE_BITOPS_H
> +
> +#include <asm/byteorder.h> /* swab32 */
> +#include <asm/system.h> /* save_flags */
> +
> +/*
> + * clear_bit() doesn't provide any barrier for the compiler.
> + */
> +#define smp_mb__before_clear_bit()     barrier()
> +#define smp_mb__after_clear_bit()      barrier()
> +
> +#include <asm-generic/bitops.h>
> +#include <asm-generic/bitops/__fls.h>
> +
> +#endif /* _ASM_SCORE_BITOPS_H */

I guess you tried using the asm-generic version of this file and
failed. Since you don't do anything architecture specific in
here, that could well mean that my version needs to be fixed.
What problem did you see?

	Arnd <><
