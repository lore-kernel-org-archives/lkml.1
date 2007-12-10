Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbXLJKLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbXLJKLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 05:11:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbXLJKLX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 05:11:23 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46089 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXLJKLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 05:11:22 -0500
Date: Mon, 10 Dec 2007 11:13:07 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com
Subject: Re: [PATCH 1/2] Kprobes: Indicate kretprobe support in arch/<arch>/Kconfig
Message-ID: <20071210101307.GA14359@uranus.ravnborg.org>
References: <20071210095221.GA19425@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210095221.GA19425@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 03:22:22PM +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This patch adds CONFIG_HAVE_KRETPROBES to the arch/<arch>/Kconfig file
> for relevant architectures with kprobes support. This facilitates easy
> handling of in-kernel modules (like samples/kprobes/kretprobe_example.c)
> that depend on kretprobes being present in the kernel.
> 
> This patch depends on Mathieu Desnoyers' "Instrumentation menu removal"
> patchset (http://marc.info/?l=linux-kernel&m=119496432229633&w=2)
> 
> Updated to apply on 2.6.24-rc4-mm1.
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  arch/avr32/Kconfig            |    5 +++++
>  arch/ia64/Kconfig             |    5 +++++
>  arch/powerpc/Kconfig          |    5 +++++
>  arch/s390/Kconfig             |    5 +++++
>  arch/sparc64/Kconfig          |    5 +++++
>  arch/x86/Kconfig              |    5 +++++
>  include/asm-ia64/kprobes.h    |    1 -
>  include/asm-powerpc/kprobes.h |    1 -
>  include/asm-s390/kprobes.h    |    1 -
>  include/asm-x86/kprobes_32.h  |    1 -
>  include/asm-x86/kprobes_64.h  |    1 -
>  include/linux/kprobes.h       |    6 +++---
>  kernel/kprobes.c              |    8 +++-----
>  13 files changed, 36 insertions(+), 13 deletions(-)
> 
> Index: linux-2.6.24-rc4/arch/avr32/Kconfig
> ===================================================================
> --- linux-2.6.24-rc4.orig/arch/avr32/Kconfig
> +++ linux-2.6.24-rc4/arch/avr32/Kconfig
> @@ -66,6 +66,11 @@ config GENERIC_BUG
>  	def_bool y
>  	depends on BUG
>  
> +config HAVE_KRETPROBES
> +	bool
> +	depends on HAVE_KPROBES
> +	default n
> +

The symbol HAVE_KRETPROBES should be defined in the common file - so
the only thing you have to do is a single line:
 config AVR32
+	select HAVE_KRETPROBES


Much more dense than defining the symbols once for each arch.

	Sam
