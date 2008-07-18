Return-Path: <linux-kernel-owner+w=401wt.eu-S1761369AbYGRR3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761369AbYGRR3s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761019AbYGRR3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:29:30 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:62582 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760987AbYGRR33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:29:29 -0400
Date: Sat, 19 Jul 2008 02:31:16 +0900 (JST)
Message-Id: <20080719.023116.122828931.anemo@mba.ocn.ne.jp>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 2/3] kgdb, mips: add arch support for the kernel's kgdb
 core
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <1216400928-29097-3-git-send-email-jason.wessel@windriver.com>
References: <1216400928-29097-1-git-send-email-jason.wessel@windriver.com>
	<1216400928-29097-2-git-send-email-jason.wessel@windriver.com>
	<1216400928-29097-3-git-send-email-jason.wessel@windriver.com>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jul 2008 12:08:47 -0500, Jason Wessel <jason.wessel@windriver.com> wrote:
> The new kgdb architecture specific handler registers and unregisters
> dynamically for exceptions depending on when you configure a kgdb I/O
> driver.  Asside from initializing the exceptions earlier in the boot
> process, kgdb should have no impact on a device when it is compiled in
> so long as an I/O module is not configured for use.
...
> @@ -133,5 +138,15 @@ void __init init_IRQ(void)
>  	for (i = 0; i < NR_IRQS; i++)
>  		set_irq_noprobe(i);
>  
> +#ifdef CONFIG_KGDB
> +	if (kgdb_early_setup)
> +		return;
> +#endif
> +
>  	arch_init_irq();
> +
> +#ifdef CONFIG_KGDB
> +	if (!kgdb_early_setup)
> +		kgdb_early_setup = 1;
> +#endif
>  }

The kgdb_ealy_setup check should be at beginning of init_IRQ (before
set_irq_noprobe loop)?

---
Atsushi Nemoto
