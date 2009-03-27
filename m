Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbZC0MvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbZC0MvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZC0MvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:51:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:63895 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbZC0Mu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:50:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: liqin.chen@sunplusct.com
Subject: Re: [PATCH 1/13] score - New architecure port to SunplusCT S+CORE processor
Date: Fri, 27 Mar 2009 13:50:44 +0100
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
References: <OF05CD1996.00155773-ON48257586.0007E097-48257586.0008511F@sunplusct.com>
In-Reply-To: <OF05CD1996.00155773-ON48257586.0007E097-48257586.0008511F@sunplusct.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903271350.45045.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX195njoH/gM6QcSThyFCV4dCRaWtyO4BvlOCzPH
 ErWrTf3AeKGlGjFyktsqj8E3vUGbevqoL2IytxXh74QZ/8Zrir
 ML7sZ4qNxzrB/DIAhUFRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 March 2009, liqin.chen@sunplusct.com wrote:
> linux/score lastest patch place at 
> http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch
> 
> diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 

First of all, welcome here and thanks for your first posting of
patches to the Linux kernel. I'll start looking through your
code soon, but would like to give you some generic advices first.

It may be a lot of things to learn at the beginning but you've already
taken the biggest step of coming out to the public with your patches.

It seems that you are not using a specific tool to post your
patches, while we have git and quilt (amongst others) that help
you prepare the patch files for submission.

Most of the points should be listed in Documentation/SubmittingPatches,
including

* specific subject lines in each mail
* threaded mails so that all of them show up together
* line wrapping
* a multiline patch description in each mail

Since the kernel development cycle has entered the merge window
for 2.6.30, you should not expect the architecture to go into
2.6.30 but you have enough time for addressing all review comments
before 2.6.31, as long as you keep posting updates. Specific
comments about code that should be done differently don't mean
that you made a mistake, because any way you do it, you will
get complaints from somebody ;-)

Ideally, you should provide a git tree or a patch set so it
can be included in linux-next at first. Please just ask if you 
need help setting up a git server.

Do you have a cross-compiler tool chain for x86 hosts somewhere
for download?

> --- linux-2.6-git.ori/arch/score/include/asm/a.out.h    1970-01-01 
> 08:00:00.000000000 +0800
> +++ linux-2.6-git.new/arch/score/include/asm/a.out.h    2009-03-13 
> 14:26:33.000000000 +0800
> @@ -0,0 +1,23 @@
> +#ifndef _ASM_A_OUT_H
> +#define _ASM_A_OUT_H
> +
> +struct exec
> +{
> +       unsigned long a_info;   /* Use macros N_MAGIC, etc for access */
> +       unsigned a_text;        /* length of text, in bytes */
> +       unsigned a_data;        /* length of data, in bytes */
> +       unsigned a_bss;         /* length of uninitialized data area for
> +                                   file, in bytes */
> +       unsigned a_syms;        /* length of symbol table data in file,
> +                                  in bytes */
> +       unsigned a_entry;       /* start address */
> +       unsigned a_trsize;      /* length of relocation info for text, in
> +                                   bytes */
> +       unsigned a_drsize;      /* length of relocation info for data, in 
> bytes */
> +};
> +
> +#define N_TRSIZE(a)    ((a).a_trsize)
> +#define N_DRSIZE(a)    ((a).a_drsize)
> +#define N_SYMSIZE(a)   ((a).a_syms)
> +
> +#endif /* _ASM_A_OUT_H */

New architectures normally don't need a.out support any more, so this
could be left out.

> linux-2.6-git.ori/arch/score/include/asm/atomic.h 

> linux-2.6-git.new/arch/score/include/asm/bitops.h

For these files (and many more), I have done a generic version that I
guess I should really post now so that you and the microblaze guys can just
use those files instead of copying new ones.

	Arnd <><
