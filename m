Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbYKXI5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbYKXI5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 03:57:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751452AbYKXI5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 03:57:25 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:51693 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYKXI5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 03:57:24 -0500
Date: Mon, 24 Nov 2008 09:57:20 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?utf-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] __used is needed for function referenced only from inline
 asm
In-Reply-To: <1227514662-10848-1-git-send-email-edwintorok@gmail.com>
Message-ID: <Pine.LNX.4.64.0811240948130.30025@anakin>
References: <1227514662-10848-1-git-send-email-edwintorok@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Török Edwin wrote:
> According to the gcc manual, the 'used' attribute should be applied to
> functions referenced only from inline assembly.
> This fixes a build failure with llvm-gcc-4.2, which deleted
> __mutex_lock_slowpath, __mutex_unlock_slowpath.
> 
> Signed-off-by: Török Edwin <edwintorok@gmail.com>
> ---
>  kernel/mutex.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/mutex.c b/kernel/mutex.c
> index 39a3816..4f45d4b 100644
> --- a/kernel/mutex.c
> +++ b/kernel/mutex.c
> @@ -59,7 +59,7 @@ EXPORT_SYMBOL(__mutex_init);
>   * We also put the fastpath first in the kernel image, to make sure the
>   * branch is predicted by the CPU as default-untaken.
>   */
> -static void noinline __sched
> +static __used noinline void __sched

Perhaps we should incorporate it into `noinline'?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
