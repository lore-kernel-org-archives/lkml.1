Return-Path: <linux-kernel-owner+w=401wt.eu-S1755634AbZGGISV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbZGGISV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZGGISL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:18:11 -0400
Received: from mail-vw0-f202.google.com ([209.85.212.202]:61386 "EHLO
	mail-vw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbZGGISJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:18:09 -0400
MIME-Version: 1.0
In-Reply-To: <87r5wt6lsg.wl%peter@chubb.wattle.id.au>
References: <87r5wt6lsg.wl%peter@chubb.wattle.id.au>
Date: Tue, 7 Jul 2009 05:18:10 -0300
Message-ID: <430c4fa50907070118k6a053333pdf81ba8c016e2d23@mail.gmail.com>
Subject: Re: [PATCH] fix resume from suspend when CONFIG_CC_STACKPROTECTOR
From: Sergio Luis <sergio@larces.uece.br>
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 7, 2009 at 3:37 AM, Peter Chubb<peter.chubb@nicta.com.au> wrote:
>
> Patch 08687aec71bc9134fe336e561f6did877bacf74fc0a (x86: unify
> power/cpu_(32|64).c)  renamed cpu_32.c to cpu.c, but did not update
> the special compilation flags for the file for the new name.
>
> This patch fixes the compilation flags, and therefore fixes resume
> from suspend on my Acer Aspire One.
>

yeah, I missed it, sorry for that. Thanks for catching it. CC'ing
Rafael and Ingo, as they will know the best way to push the fix.

> Signed-off-by: Peter Chubb <peterc@nicta.com.au>
> ---
>  arch/x86/power/Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: linux-2.6/arch/x86/power/Makefile
> ===================================================================
> --- linux-2.6.orig/arch/x86/power/Makefile      2009-07-07 13:39:54.000000000 +1000
> +++ linux-2.6/arch/x86/power/Makefile   2009-07-07 13:40:14.000000000 +1000
> @@ -1,7 +1,7 @@
>  # __restore_processor_state() restores %gs after S3 resume and so should not
>  # itself be stack-protected
>  nostackp := $(call cc-option, -fno-stack-protector)
> -CFLAGS_cpu_$(BITS).o   := $(nostackp)
> +CFLAGS_cpu.o   := $(nostackp)
>
>  obj-$(CONFIG_PM_SLEEP)         += cpu.o
>  obj-$(CONFIG_HIBERNATION)      += hibernate_$(BITS).o hibernate_asm_$(BITS).o
>
> --
> Dr Peter Chubb                                  peter DOT chubb AT nicta.com.au
> http://www.ertos.nicta.com.au               ERTOS within National ICT Australia
> All things shall perish from under the sky/Music alone shall live, never to die
>

Sergio.
