Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZAXMK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZAXMK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 07:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbZAXMKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 07:10:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:8013 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463AbZAXMKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 07:10:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZVMQdm62z7ZjMMWrbEtkxJj8pJwRwqsIalN6kIhb8yUPByHI9t4y49zSxng/I7oYP8
         y5iyAvIkIa0rerHuejFO53KOSgg65UaVl3zs1DMm4N+4nivffWjyXqeh2TMZ3Ybeg5li
         7CSZo+Gb0tGUChtnxAl3SBPVUD6bcXXGkCo3A=
MIME-Version: 1.0
In-Reply-To: <1231903597.5756.4.camel@brick>
References: <1231903597.5756.4.camel@brick>
Date: Sat, 24 Jan 2009 17:40:14 +0530
Message-ID: <3f9a31f40901240410r44451621n3dfaf808dfa9b01d@mail.gmail.com>
Subject: Re: [PATCH 1/2] cris: introduce asm/swab.h
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesper Nilsson <jesper.nilsson@axis.com>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 8:56 AM, Harvey Harrison
<harvey.harrison@gmail.com> wrote:
> Adjust the arch overrides to the new names as well.
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Jesper, I noticed that my patch was the only one for CRIS this merge
> window (at least looking at linux-next), I hope you're OK with me
> sending this directly to Linus.  It's just code movement, so I'm
> confident it's not going to break anything.
>
>  arch/cris/include/arch-v10/arch/byteorder.h |   26 -----------------------
>  arch/cris/include/arch-v10/arch/swab.h      |   30 +++++++++++++++++++++++++++
>  arch/cris/include/arch-v32/arch/byteorder.h |   20 ------------------
>  arch/cris/include/arch-v32/arch/swab.h      |   24 +++++++++++++++++++++
>  arch/cris/include/asm/Kbuild                |    1 +
>  arch/cris/include/asm/byteorder.h           |   20 +-----------------
>  arch/cris/include/asm/swab.h                |    8 +++++++
>  7 files changed, 64 insertions(+), 65 deletions(-)
>
> diff --git a/arch/cris/include/arch-v10/arch/swab.h b/arch/cris/include/arch-v10/arch/swab.h
> new file mode 100644
> index 0000000..e4e847d
> --- /dev/null
> +++ b/arch/cris/include/arch-v10/arch/swab.h
> @@ -0,0 +1,30 @@
> +#ifndef _CRIS_ARCH_SWAB_H
> +#define _CRIS_ARCH_SWAB_H
> +
> +#include <asm/types.h>

Please replace #include <asm/types.h> with #include <linux/types.h>
otherwise you will get following 'make headers_check' warnings:
  usr/include/asm/swab.h:4: include of <linux/types.h> is preferred
over <asm/types.h>
  usr/include/asm/swab.h:14: found __[us]{8,16,32,64} type without
#include <linux/types.h>

> diff --git a/arch/cris/include/arch-v32/arch/swab.h b/arch/cris/include/arch-v32/arch/swab.h
> new file mode 100644
> index 0000000..1152329
> --- /dev/null
> +++ b/arch/cris/include/arch-v32/arch/swab.h
> @@ -0,0 +1,24 @@
> +#ifndef _ASM_CRIS_ARCH_SWAB_H
> +#define _ASM_CRIS_ARCH_SWAB_H
> +
> +#include <asm/types.h>

ditto.

If possible, please also fix your other patches which are in queue.

--
JSR
