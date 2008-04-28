Return-Path: <linux-kernel-owner+w=401wt.eu-S932212AbYD1JBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212AbYD1JBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYD1JBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:01:36 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:9709 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbYD1JBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:01:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TxLQtWZPEB+YUoGtYLNdgu2y5+7mbf2b4GVkAdguIYWtYqZo18wnv5t5Wk2KWCQcVIGxiZM2z5zJJk9IaGjIjj7MfyIhD0Az1z7UVxxiTDcsB5VQd6f0XzVVZxZEUQyfjyT01g9c3Wwfm8CUEvgVQG2nw++8UyAWOkeKZCjJPLg=
Message-ID: <ce0170d90804280201v77e4302crb8171357a3ef3bbc@mail.gmail.com>
Date: Mon, 28 Apr 2008 06:01:34 -0300
From: "Sergio Luis" <sergio@uece.br>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] build fix for smp
Cc: "Glauber de Oliveira Costa" <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de, "Avi Kivity" <avi@qumranet.com>
In-Reply-To: <20080428085044.GB16963@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <12059466674071-git-send-email-gcosta@redhat.com>
	 <20080319195217.GA20762@elte.hu>
	 <ce0170d90804280052y130c3fa2pbf3f97147f03b159@mail.gmail.com>
	 <20080428085044.GB16963@elte.hu>
X-Google-Sender-Auth: aed45ae1ee9970e1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 5:50 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Sergio Luis <sergio@uece.br> wrote:
>
>  > Hello, what's the final fix for this issue? 2.6.25-git11 is still
>  > broken, just gave me
>
>  > arch/x86/kernel/built-in.o: In function `native_smp_send_stop':
>  > smp.c:(.text+0xc751): undefined reference to `reboot_force'
>  > make: *** [.tmp_vmlinux1] Error 1
>
>  > for a randconfig. Same reported at http://lkml.org/lkml/2008/4/27/39
>
>  btw., that's a VISWS config - that wont boot on any PC. The patch below
>  should fix this.

Yep, it does fix it thanks.
-sergio

>
>         Ingo
>
>  --------------------------->
>  Subject: x86 VISWS: build fix
>  From: Ingo Molnar <mingo@elte.hu>
>  Date: Mon Apr 28 10:46:58 CEST 2008
>
>  the 'reboot_force' flag is a notion that non-PC subarchitectures do
>  not have.
>
>  Signed-off-by: Ingo Molnar <mingo@elte.hu>
>  ---
>   include/asm-x86/proto.h |    4 ++++
>   1 file changed, 4 insertions(+)
>
>  Index: linux/include/asm-x86/proto.h
>  ===================================================================
>  --- linux.orig/include/asm-x86/proto.h
>  +++ linux/include/asm-x86/proto.h
>  @@ -20,7 +20,11 @@ extern void syscall32_cpu_init(void);
>
>   extern void check_efer(void);
>
>  +#ifdef X86_BIOS_REBOOT
>   extern int reboot_force;
>  +#else
>  +static const int reboot_force = 0;
>  +#endif
>
>   long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
>
>
