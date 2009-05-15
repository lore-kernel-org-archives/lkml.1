Return-Path: <linux-kernel-owner+w=401wt.eu-S1760409AbZEOKXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409AbZEOKXY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 06:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZEOKXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 06:23:15 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37429 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082AbZEOKXO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 06:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GS8alE9P5jnc6CvMejCel2Ks/hBgYXSmfamv7SNuErXbpeLlYozP2s6wiue4p/i5z3
         IXAuRYJOC8xvYfJfVQ2O5rEB/sFwyFjPaxL65S+or6W1nKgYmWLtFVd6fwTUSlM5c/9U
         Jaj0ObSzknnpmJbqB+clGkNtZCZpQ1GzMMwKs=
MIME-Version: 1.0
In-Reply-To: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
Date: Fri, 15 May 2009 13:23:14 +0300
X-Google-Sender-Auth: 70bbe52e137c500d
Message-ID: <84144f020905150323m76cdd775p87abec356e355d37@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Floris Kraak <randakar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wed, Feb 4, 2009 at 5:28 PM, Floris Kraak <randakar@gmail.com> wrote:
> Some distributions have enabled the gcc flag -Wformat-security by default.*
> This results in a number of warnings about format arguments to
> functions, sometimes in cases where fixing the warning is not likely
> to actually fix a bug.
> Instead of hand patching a dozens of places (possibly more) that
> produce warnings that get ignored anyway we just turn off the flag in
> the Makefile.
>
> Note: Regardless of any discussion surrounding the value of this
> particular type of warning, having this show up in a few distributions
> but not in the
> vast majority of them means that this warning won't be seen by most of
> the developers who introduce the new warnings in the first place. If
> the
> kernel decides it cares about format arguments it should do so
> globally regardless of distribution. In which case I'd gladly whip up
> a patch to do
> the reverse thing and turn this thing on by default. However, such a
> patch would have to produce a follow up patch(set) which fixes each
> individual
> warning.
>
> See also:
> http://kerneltrap.org/mailarchive/linux-kernel/2008/11/20/4215134
>
> *) The ubuntu manpage for gcc states:
>
>      -Wformat-security
>          If -Wformat is specified, also warn about uses of format
> functions that represent possible security problems.  At present, this
> warns about
>          calls to "printf" and "scanf" functions where the format
> string is not a string literal and there are no format arguments, as
> in "printf
>          (foo);".  This may be a security hole if the format string
> came from untrusted input and contains %n.  (This is currently a
> subset of what
>          -Wformat-nonliteral warns about, but in future warnings may
> be added to -Wformat-security that are not included in
> -Wformat-nonliteral.)
>
>          NOTE: In Ubuntu 8.10 and later versions this option is
> enabled by default for C, C++, ObjC, ObjC++.  To disable, use
> -Wno-format-security, or
>          disable all format warnings with -Wformat=0.  To make format
> security warnings fatal, specify -Werror=format-security.
>
> Signed-off-by: Floris Kraak <randakar@gmail.com>
> ---
> diff --git a/Makefile b/Makefile
> index 7715b2c..9ee766c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -346,7 +346,8 @@ KBUILD_CPPFLAGS := -D__KERNEL__
>
>  KBUILD_CFLAGS   := -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
>                   -fno-strict-aliasing -fno-common \
> -                  -Werror-implicit-function-declaration
> +                  -Werror-implicit-function-declaration \
> +                  -Wno-format-security
>  KBUILD_AFLAGS   := -D__ASSEMBLY__
>
>  # Read KERNELRELEASE from include/config/kernel.release (if it exists)

Is there a reason this patch was not merged? Yes, it's clearly a
distro problem but apparently there's no easy way to turn it off.

                                           Pekka
