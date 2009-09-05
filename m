Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbZIELuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbZIELuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 07:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbZIELuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 07:50:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40210 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbZIELuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 07:50:19 -0400
Subject: Re: [PATCH] x86: Fix 20 section mismatch warnings from x86_init,
 arch/x86/kernel/x86_init.c
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1252149641.4969.7.camel@ht.satnam>
References: <1252149270.4969.6.camel@ht.satnam>
	 <1252149641.4969.7.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 05 Sep 2009 17:16:17 +0530
Message-Id: <1252151177.4969.11.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-09-05 at 16:50 +0530, Jaswinder Singh Rajput wrote:
> Check http://marc.info/?l=linux-kernel&m=125214951924366&w=2 to see more details.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> ---
>  arch/x86/kernel/x86_init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
> index 24be7f3..81dd9d0 100644
> --- a/arch/x86/kernel/x86_init.c
> +++ b/arch/x86/kernel/x86_init.c
> @@ -23,7 +23,7 @@ void __init x86_init_pgd_noop(pgd_t *unused) { }
>   * The platform setup functions are preset with the default functions
>   * for standard PC hardware.
>   */
> -struct __initdata x86_init_ops x86_init = {
> +struct __initdata x86_init_ops x86_init_ops = {
>  
>  	.resources = {
>  		.probe_roms		= x86_init_noop,

x86_init is used by many files and this breaks the kernel :

arch/x86/built-in.o: In function `init_IRQ':
(.text+0x4b12): undefined reference to `x86_init'
arch/x86/built-in.o: In function `trap_init':
(.init.text+0x385): undefined reference to `x86_init'
arch/x86/built-in.o: In function `x86_late_time_init':
time.c:(.init.text+0x39f): undefined reference to `x86_init'
arch/x86/built-in.o: In function `setup_arch':
(.init.text+0x80b): undefined reference to `x86_init'
arch/x86/built-in.o: In function `setup_arch':
(.init.text+0xa32): undefined reference to `x86_init'
arch/x86/built-in.o:(.init.text+0xc5e): more undefined references to `x86_init' follow

Now we need to look for some another option.

Thomas, any suggestions.

Thank you,
--
JSR

