Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbXJYRXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbXJYRXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 13:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbXJYRX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 13:23:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40380 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbXJYRXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 13:23:25 -0400
Message-ID: <4720D0F5.4040407@zytor.com>
Date: Thu, 25 Oct 2007 10:23:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Glauber de Oliveira Costa <gcosta@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, glommer@gmail.com
Subject: Re: [PATCH] Wipe out traditional opt from x86_64 Makefile
References: <11933164723812-git-send-email-gcosta@redhat.com>
In-Reply-To: <11933164723812-git-send-email-gcosta@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber de Oliveira Costa wrote:
> Among other things, using -traditional as a gcc option stops us from
> using macro token pasting, which is a feature we heavily rely on.
> 
> There was still a use of -traditional in arch/x86/kernel/Makefile_64,
> which this patch removes.
> 
> I don't see any problems building kernels in my x86_64 box without
> -traditional.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> ---
>  arch/x86/kernel/Makefile_64 |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/Makefile_64 b/arch/x86/kernel/Makefile_64
> index 82da906..03a01f6 100644
> --- a/arch/x86/kernel/Makefile_64
> +++ b/arch/x86/kernel/Makefile_64
> @@ -3,7 +3,6 @@
>  #
>  
>  extra-y 	:= head_64.o head64.o init_task.o vmlinux.lds
> -#EXTRA_AFLAGS	:= -traditional
>  obj-y	:= process_64.o signal_64.o entry_64.o traps_64.o irq_64.o \
>  		ptrace_64.o time_64.o ioport_64.o ldt_64.o setup_64.o i8259_64.o sys_x86_64.o \
>  		x8664_ksyms_64.o i387_64.o syscall_64.o vsyscall_64.o \

At least *at one point*, ld scripts were whitespace-sensitive in a way 
that called for using -traditional.  Doesn't mean that anything else 
needs it, though.

	-hpa
