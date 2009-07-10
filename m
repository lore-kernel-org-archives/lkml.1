Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZGJFXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZGJFXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbZGJFX0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:23:26 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZGJFXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:23:25 -0400
Date: Fri, 10 Jul 2009 07:23:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 02/12] SFI, x86: add CONFIG_SFI
Message-ID: <20090710052306.GC22218@elte.hu>
References: <8e4a93858bce74ed3080dd607aa471023f1a2737.1247025117.git.len.brown@intel.com> <d5a8e3203627c313e8fdbf4fa9ac1cb1cdc6706c.1247025117.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5a8e3203627c313e8fdbf4fa9ac1cb1cdc6706c.1247025117.git.len.brown@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Len Brown <lenb@kernel.org> wrote:

> +++ b/drivers/sfi/Kconfig
> @@ -0,0 +1,16 @@
> +#
> +# SFI Configuration
> +#
> +
> +menuconfig SFI
> +	bool "SFI (Simple Firmware Interface) Support"
> +	depends on X86

Instead of 'depends on X86' it's cleaner to add a HAVE_ARCH_SFI 
Kconfig variable to arch/x86/Kconfig, and turn the above into:

	depends on HAVE_ARCH_SFI

That will make it easier to enable it on other architectures such as 
IA64, should the need arise - and it's cleaner in any case.

> +	default n

Kconfig uses 'default n' by default, so this line can be left out.

> +	---help---
> +	The Simple Firmware Interface (SFI) provides a lightweight method
> +	for platform firmware to pass information to the Operating System
> +	via static tables in memory.
> +
> +	For more information, see http://simplefirmware.org
> +
> +	Say 'Y' here to enable the kernel to boot on SFI-only platforms.

Nitpick: s/Operating System/Linux kernel

(and even if we want to formulate it in a general way, it should be 
'operating system')

	Ingo
