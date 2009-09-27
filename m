Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZI0Jzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZI0Jzy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 05:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbZI0Jzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 05:55:52 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:62360 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbZI0Jzv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 05:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=LsZr/CtcbqV3ptUbL+fr0bT0QLiLJdPp0yJ/eatZDnE1SNBPvL0EQmdZ+Dhzu5w7tr
         mTPUdmNymZQWKo+1aBT/3CmDGQUomittiT/vPQ7y47kIYRBfaELPYr6PD8w05tOU0MoA
         EaNCCQNkmxvMiuB5VYPfSeIuffB8BooPRzHM4=
MIME-Version: 1.0
In-Reply-To: <1253119466-19488-2-git-send-email-tabbott@ksplice.com>
References: <1253119466-19488-1-git-send-email-tabbott@ksplice.com>
	 <1253119466-19488-2-git-send-email-tabbott@ksplice.com>
Date: Sun, 27 Sep 2009 11:55:55 +0200
X-Google-Sender-Auth: 517538b937a8ad33
Message-ID: <10f740e80909270255y18c2840bh14c6a4ddfdb0a916@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] m68k: Make thread_info.h usable from assembly.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 18:44, Tim Abbott <tabbott@ksplice.com> wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Cc: linux-m68k@lists.linux-m68k.org
> Cc: Sam Ravnborg <sam@ravnborg.org>
> ---
>  arch/m68k/include/asm/thread_info_mm.h |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/m68k/include/asm/thread_info_mm.h b/arch/m68k/include/asm/thread_info_mm.h
> index b6da388..5f36cf1 100644
> --- a/arch/m68k/include/asm/thread_info_mm.h
> +++ b/arch/m68k/include/asm/thread_info_mm.h
> @@ -8,6 +8,7 @@
>  #include <asm/types.h>
>  #include <asm/page.h>
>
> +#ifndef __ASSEMBLY__
>  struct thread_info {
>        struct task_struct      *task;          /* main task structure */
>        unsigned long           flags;
> @@ -16,6 +17,7 @@ struct thread_info {
>        __u32 cpu; /* should always be 0 on m68k */
>        struct restart_block    restart_block;
>  };
> +#endif /* __ASSEMBLY__ */
>
>  #define PREEMPT_ACTIVE         0x4000000

This is not sufficient. <asm/thread_info_mm.h> pulls in <asm/current.h>,
which contains C only. So you also need:

--- a/arch/m68k/include/asm/thread_info_mm.h
+++ b/arch/m68k/include/asm/thread_info_mm.h
@@ -4,11 +4,12 @@
 #ifndef ASM_OFFSETS_C
 #include <asm/asm-offsets.h>
 #endif
-#include <asm/current.h>
 #include <asm/types.h>
 #include <asm/page.h>

 #ifndef __ASSEMBLY__
+#include <asm/current.h>
+
 struct thread_info {
 	struct task_struct	*task;		/* main task structure */
 	unsigned long		flags;


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
