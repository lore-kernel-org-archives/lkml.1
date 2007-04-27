Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbXD0QZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbXD0QZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756049AbXD0QZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:25:38 -0400
Received: from gw.goop.org ([64.81.55.164]:58194 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056AbXD0QZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:25:15 -0400
Message-ID: <463223E9.7050705@goop.org>
Date: Fri, 27 Apr 2007 09:25:13 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Machek <pavel@ucw.cz>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] Separate freezer from PM code
References: <200704271737.31192.rjw@sisk.pl> <200704271738.48429.rjw@sisk.pl>
In-Reply-To: <200704271738.48429.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
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
>   

Shouldn't PM and KPROBES "select" FREEZER if they want it?  That way its
easier for other future users of FREEZER to do so without having to
change the Kconfig here (and the other 23000 Kconfigs).

    J
