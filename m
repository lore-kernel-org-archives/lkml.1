Return-Path: <linux-kernel-owner+w=401wt.eu-S965631AbXG2Wve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965631AbXG2Wve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 18:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965039AbXG2WvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 18:51:08 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:50281 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965002AbXG2WvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 18:51:06 -0400
Date: Mon, 30 Jul 2007 07:50:24 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <lkmladrian@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: Re: Fwd: [PATCH] Reboot Dreamcast under software control
Message-ID: <20070729225024.GA8039@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <lkmladrian@gmail.com>,
	linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
References: <8b67d60707291104k64ba6e0dpf86a7604ce63ae8e@mail.gmail.com> <8b67d60707291125o5c78d87dq59c842a9dac3e521@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b67d60707291125o5c78d87dq59c842a9dac3e521@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 29, 2007 at 07:25:21PM +0100, Adrian McMenamin wrote:
> diff --git a/arch/sh/kernel/process.c b/arch/sh/kernel/process.c
> index 6334a4c..6f5e9e4 100644
> --- a/arch/sh/kernel/process.c
> +++ b/arch/sh/kernel/process.c
> @@ -97,6 +97,11 @@ void cpu_idle(void)
> 
>  void machine_restart(char * __unused)
>  {
> +
> +#ifdef CONFIG_SH_DREAMCAST
> +       /*reboot the Dreamcast under software control*/
> +       writel(0x00007611, 0xA05F6890);
> +#endif
>         /* SR.BL=1 and invoke address error to let CPU reset (manual reset) */
>         asm volatile("ldc %0, sr\n\t"
>                      "mov.l @%1, %0" : : "r" (0x10000000), "r" (0x80000001));

No, if you want to do this, at least use a function pointer and leave
this as the default implementation. The dreamcast presumably only needs
this magic write anyways, rather than the SR.BL trick.
