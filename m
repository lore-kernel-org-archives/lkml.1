Return-Path: <linux-kernel-owner+w=401wt.eu-S1757067AbZBERz2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757067AbZBERz2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:55:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751540AbZBERzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:55:17 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:58716 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZBERzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:55:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RHXjAfYjASGyxwpXj/2cvjGC/17ie5Krhibf404h6qu5AT/aK0P/9kGtEhzs3p0Vjc
         XXpDcBpT1UoPYnP6uL8zy0Dbe1tWymUEvHzhSerg/4w/fcsrj6nWQKHflo/aij8E2d+d
         SUY/RHpYm494PmT7vmGA9ppC1XML/Mcb6exSw=
MIME-Version: 1.0
In-Reply-To: <1233385816.17794.16.camel@localhost.localdomain>
References: <1233385816.17794.16.camel@localhost.localdomain>
Date: Thu, 5 Feb 2009 09:55:13 -0800
X-Google-Sender-Auth: 72176f87bc76b10e
Message-ID: <12c511ca0902050955x1acb3907jdbfc1d0e6392cb91@mail.gmail.com>
Subject: Re: [git pull -tip] headers_check fixes for other architectures
From: Tony Luck <tony.luck@intel.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       hskinnemoen@atmel.com, cooloney@kernel.org, ralf@linux-mips.org,
       dhowells@redhat.com, matthew@wil.cx, chris@zankel.net,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 30, 2009 at 11:10 PM, Jaswinder Singh Rajput
<jaswinder@kernel.org> wrote:
> These are clean patches, I did not included anything which leads to any
> confusion or conflicts. I hope maintainers do not mind if these patches
> go to mainstream via Ingo's -tip along with other headers_check fixes.
>      headers_check fix: ia64, fpu.h

> diff --git a/arch/ia64/include/asm/fpu.h b/arch/ia64/include/asm/fpu.h
> index 3859558..b6395ad 100644
> --- a/arch/ia64/include/asm/fpu.h
> +++ b/arch/ia64/include/asm/fpu.h
> @@ -6,7 +6,7 @@
>  *     David Mosberger-Tang <davidm@hpl.hp.com>
>  */
>
> -#include <asm/types.h>
> +#include <linux/types.h>
>
>  /* floating point status register: */
>  #define FPSR_TRAP_VD   (1 << 0)        /* invalid op trap disabled */

This one breaks the ia64 build for linux-next (since some assembly files
include <asm/fpu.h> which then goes on to pull in a whole bunch of
"C" include files that don't have __ASSEMBLY__ guards and so the
assembler chokes on "enum" and "typedef" etc.)

Either revert this part ... or wrap the #include like this in fpu.h:

#ifndef __ASSEMBLY__
#include <linux/types.h>
#endif

Thanks

-Tony
