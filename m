Return-Path: <linux-kernel-owner+w=401wt.eu-S1752395AbZH0MXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395AbZH0MXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbZH0MXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:23:19 -0400
Received: from mail-pz0-f184.google.com ([209.85.222.184]:38539 "EHLO
	mail-pz0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbZH0MXS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:23:18 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Aug 2009 08:23:18 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=arIYzQMY7pVPQwT6ESSRm5sUsmu9JjRDEoBnaAehWZ+6pjhK79w4bWX6aGk1JpJH+j
         eoSIyJ1Mz9mxzCoQ9v1fs7USympduA/H1f0d43pdK9OAV+kQzGKjm8RQl9O41H8Yk+AP
         zFYyqSDjmaCDOVokhtf+XEFpz9zYA/qXFOzNs=
MIME-Version: 1.0
In-Reply-To: <20090827114157.GA8678@osiris.boeblingen.de.ibm.com>
References: <20090827114157.GA8678@osiris.boeblingen.de.ibm.com>
Date: Thu, 27 Aug 2009 14:18:05 +0200
X-Google-Sender-Auth: 8ef848c7ee062c39
Message-ID: <10f740e80908270518u3812b96ew574eabff21f369e5@mail.gmail.com>
Subject: Re: [PATCH] m68k: avoid pgprot_noncached redefinition
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Greg Ungerer <gerg@uclinux.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 13:41, Heiko Carstens<heiko.carstens@de.ibm.com> wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
>
> While compiling m68k with defconfig I get tons if these warnings:
>
> /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable_mm.h:148:1: warning: "pgprot_noncached" redefined
> In file included from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable_mm.h:138,
>  from /home2/heicarst/linux-2.6/arch/m68k/include/asm/pgtable.h:4,
>  from include/linux/mm.h:38,
>  from /home2/heicarst/linux-2.6/arch/m68k/include/asm/atarihw.h:134,
>  from arch/m68k/atari/debug.c:20:
> include/asm-generic/pgtable.h:133:1: warning: this is the location of the previous definition
>
> Reason for this is that asm-generic/pgtable.h gets included in pgtable_mm.h
> before pgprot_noncached gets defined.
> So the check "#ifndef pgprot_noncached" in the generic header file is too early.
> Solve this by including the generic header file after the arch define.

Thanks, but Linus has just pulled the fix last night.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
