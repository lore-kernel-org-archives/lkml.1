Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260AbYGXQ0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbYGXQ0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 12:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbYGXQZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 12:25:56 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:55864 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbYGXQZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 12:25:56 -0400
Date: Fri, 25 Jul 2008 01:27:48 +0900 (JST)
Message-Id: <20080725.012748.108121457.anemo@mba.ocn.ne.jp>
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
> diff --git a/include/asm-mips/kgdb.h b/include/asm-mips/kgdb.h
...
> +static inline void arch_kgdb_breakpoint(void)
> +{
> +	__asm__ __volatile__(
> +		".globl breakinst\n\t"
> +		".set\tnoreorder\n\t"
> +		"nop\n"
> +		"breakinst:\tbreak\n\t"
> +		"nop\n\t"
> +		".set\treorder");
> +}

The gcc might inline kgdb_breakpoint() which includes
arch_kgdb_breakpoint().  I got this error with gcc 4.3.1:

  CC      kernel/kgdb.o
{standard input}: Assembler messages:
{standard input}:809: Error: symbol `breakinst' is already defined
{standard input}:913: Error: symbol `breakinst' is already defined
{standard input}:1233: Error: symbol `breakinst' is already defined

Moving arch_kgdb_breakpoint() into arch/mips/kernel/kgdb.c should
solve the problem.

---
Atsushi Nemoto
