Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbZIQFM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbZIQFM7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 01:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZIQFM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 01:12:58 -0400
Received: from mail-pz0-f190.google.com ([209.85.222.190]:44760 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363AbZIQFM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 01:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tQmGY3Cy1w/CrXD993qh5oCrY7IV8KueSTWinPaeYCppvZ/0tT/G8cNKPc0W57pnl7
         4HAP21YJjrUOBp2Icu6Qqbk8e1BIJ9Khx8gpoxx0nzPlnKt69HyzbewOwoDgWDsz19b+
         ogXQb0LOSgqYP1BZrrPHD/66eBoG1UGE8wAlc=
MIME-Version: 1.0
In-Reply-To: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
References: <830a8fa70909161930r518a9644ja954ced2ae5814b4@mail.gmail.com>
Date: Wed, 16 Sep 2009 21:40:57 -0700
Message-ID: <830a8fa70909162140h4088de90l16e806629fa943b@mail.gmail.com>
Subject: Re: [patch] Makefile: can't build modules outside the kernel tree if 
	it was built using O=
From: Caveh Jalali <ecaveh@gmail.com>
To: sam@ravnborg.org
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it's known good in 2.6.25, borked in 2.6.31.  i didn't track down
the kernel version number where the offending commit showed up.

anyway, here's my SOB:

Signed-off-by: Caveh Jalali <ecaveh@gmail.com>

On Wed, Sep 16, 2009 at 7:30 PM, Caveh Jalali <ecaveh@gmail.com> wrote:
> in 2.6.31, it is no longer possible to build kernel modules for some platforms
> (the ones that need include2) outside the kernel src tree if the
> src tree was built using O= to specify an alternate directory for the
> build output.
>
> i think this broke with the following commit:
>
> commit b8b572e1015f81b4e748417be2629dfe51ab99f9
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Fri Aug 1 15:20:30 2008 +1000
>
>    powerpc: Move include files to arch/powerpc/include/asm
>
>
> when the platform specific include directories were shuffled around
> without updating the
> top level Makefile.  however, i think this FAIL is generic, and not
> limited to powerpc.
> here's a patch to the top level Makefile to teach it about the shuffled files:
>
>
> --- /local/caveh/linux/linux-2.6.31/Makefile    2009-09-09
> 15:13:59.000000000 -0700
> +++ Makefile    2009-09-16 12:23:05.000000000 -0700
> @@ -958,9 +958,9 @@ ifneq ($(KBUILD_SRC),)
>                 echo "  in the '$(srctree)' directory.";\
>                 /bin/false; \
>         fi;
> -       $(Q)if [ ! -d include2 ]; then                                  \
> -           mkdir -p include2;                                          \
> -           ln -fsn $(srctree)/include/asm-$(SRCARCH) include2/asm;     \
> +       $(Q)if [ ! -d include2 ]; then                                   \
> +           mkdir -p include2;                                           \
> +           ln -fsn $(srctree)/arch/$(SRCARCH)/include/asm include2/asm; \
>         fi
>  endif
>



-- 
00c
http://www.boincstats.com/signature/user_870433_project5.gif
