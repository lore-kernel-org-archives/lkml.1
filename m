Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbZB0Asc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbZB0Asc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 19:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbZB0AsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 19:48:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:51466 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZB0AsW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 19:48:22 -0500
MIME-Version: 1.0
In-Reply-To: <20090222000051.17557.85888.stgit@vmbox.hanneseder.net>
References: <20090221235706.17557.97714.stgit@vmbox.hanneseder.net>
	 <20090222000051.17557.85888.stgit@vmbox.hanneseder.net>
Date: Fri, 27 Feb 2009 01:48:19 +0100
Message-ID: <154e089b0902261648s614be164hf4d4340543f9f0d5@mail.gmail.com>
Subject: Re: [PATCH 01/16] kexec/i386: fix sparse warnings: Using plain 
	integer as NULL pointer
From: Hannes Eder <hannes@hanneseder.net>
To: Ingo Molnar <mingo@elte.hu>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added To: Ingo Molnar <mingo@elte.hu>

On Sun, Feb 22, 2009 at 1:00 AM, Hannes Eder <hannes@hanneseder.net> wrote:
> Fix this sparse warnings:
>  arch/x86/kernel/machine_kexec_32.c:124:22: warning: Using plain integer as NULL pointer
>  arch/x86/kernel/traps.c:950:24: warning: Using plain integer as NULL pointer
>
> Signed-off-by: Hannes Eder <hannes@hanneseder.net>
> ---
>  arch/x86/kernel/machine_kexec_32.c |    2 +-
>  arch/x86/kernel/traps.c            |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/machine_kexec_32.c b/arch/x86/kernel/machine_kexec_32.c
> index 37f4200..f5fc8c7 100644
> --- a/arch/x86/kernel/machine_kexec_32.c
> +++ b/arch/x86/kernel/machine_kexec_32.c
> @@ -121,7 +121,7 @@ static void machine_kexec_page_table_set_one(
>  static void machine_kexec_prepare_page_tables(struct kimage *image)
>  {
>        void *control_page;
> -       pmd_t *pmd = 0;
> +       pmd_t *pmd = NULL;
>
>        control_page = page_address(image->control_code_page);
>  #ifdef CONFIG_X86_PAE
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index ba90406..6882089 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -947,7 +947,7 @@ dotraplinkage void do_iret_error(struct pt_regs *regs, long error_code)
>        info.si_signo = SIGILL;
>        info.si_errno = 0;
>        info.si_code = ILL_BADSTK;
> -       info.si_addr = 0;
> +       info.si_addr = NULL;
>        if (notify_die(DIE_TRAP, "iret exception",
>                        regs, error_code, 32, SIGILL) == NOTIFY_STOP)
>                return;
>
>
