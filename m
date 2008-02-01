Return-Path: <linux-kernel-owner+w=401wt.eu-S1764927AbYBAN3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764927AbYBAN3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 08:29:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763006AbYBAN2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 08:28:53 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:46573 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756217AbYBAN2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 08:28:52 -0500
Date: Fri, 1 Feb 2008 14:28:54 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Holger Wolf <wolf@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] latencytop: Change Kconfig dependency.
Message-ID: <20080201132854.GB13251@uranus.ravnborg.org>
References: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080201130636.GA29660@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 02:06:36PM +0100, Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Change latencytop Kconfig entry so it doesn't list the archictectures
> that support it. Instead introduce HAVE_LATENCY_SUPPORT which any
> architecture can set. Should reduce patch conflicts.
> 
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Holger Wolf <wolf@linux.vnet.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
> 
> If ok, should this go in via the x86 tree?
> 
>  arch/x86/Kconfig  |    3 +++
>  lib/Kconfig.debug |    2 +-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -44,6 +44,9 @@ config LOCKDEP_SUPPORT
>  config STACKTRACE_SUPPORT
>  	def_bool y
>  
> +config HAVE_LATENCYTOP_SUPPORT
> +	def_bool y
> +
No.
Please do:
 config X86
+	select HAVE_LATENCYTOP_SUPPORT

Yes - this is a valid use of select.

See Documentation/kbuild/kconfig-language.txt

Sam
