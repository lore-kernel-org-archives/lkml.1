Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbXD0QOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbXD0QOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbXD0QOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:14:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37429 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047AbXD0QOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:14:19 -0400
Date: Fri, 27 Apr 2007 18:15:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] Separate freezer from PM code
Message-ID: <20070427161503.GA1046@uranus.ravnborg.org>
References: <200704271737.31192.rjw@sisk.pl> <200704271738.48429.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704271738.48429.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 05:38:47PM +0200, Rafael J. Wysocki wrote:
> 
> Index: linux-2.6.21-rc7-mm2/arch/x86_64/Kconfig
> ===================================================================
> --- linux-2.6.21-rc7-mm2.orig/arch/x86_64/Kconfig	2007-04-27 01:22:33.000000000 +0200
> +++ linux-2.6.21-rc7-mm2/arch/x86_64/Kconfig	2007-04-27 01:33:22.000000000 +0200
> @@ -703,6 +703,14 @@ config GENERIC_PENDING_IRQ
>  	depends on GENERIC_HARDIRQS && SMP
>  	default y
>  
> +#
> +# Use the tasks freezer
> +#
> +config FREEZER
> +	bool
> +	default y
> +	depends on PM || KPROBES
> +
>  menu "Power management options"

Could we have this in a generic Kconfig file instead?
IIRC the depends on line may refer to unknown options
without spitting out warnings.

	Sam
