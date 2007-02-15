Return-Path: <linux-kernel-owner+w=401wt.eu-S964895AbXBOD5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895AbXBOD5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 22:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964897AbXBOD5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 22:57:22 -0500
Received: from smtp.osdl.org ([65.172.181.24]:32878 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964895AbXBOD5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 22:57:21 -0500
Date: Wed, 14 Feb 2007 19:57:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: minyard@acm.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] ipmi: add new IPMI nmi watchdog handling
Message-Id: <20070214195718.e78458cf.akpm@linux-foundation.org>
In-Reply-To: <20070214201257.GD5364@localdomain>
References: <20070214201257.GD5364@localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 14:12:57 -0600 Corey Minyard <minyard@acm.org> wrote:

> 
> Convert over to the new NMI handling for getting IPMI watchdog
> timeouts via an NMI.  This add config options to know if there
> is the ability to receive NMIs and if it has an NMI post processing
> call.  Then it modifies the IPMI watchdog to take advantage of
> this so that it can know if an NMI comes in.
> 
> It also adds testing that the IPMI NMI watchdog works.
> 
> Signed-off-by: Corey Minyard <minyard@acm.org>
> 
> Index: linux-2.6.19-rc6/arch/i386/Kconfig.debug
> ===================================================================
> --- linux-2.6.19-rc6.orig/arch/i386/Kconfig.debug
> +++ linux-2.6.19-rc6/arch/i386/Kconfig.debug
> @@ -4,6 +4,10 @@ config TRACE_IRQFLAGS_SUPPORT
>  	bool
>  	default y
>  
> +config HAVE_STANDARD_NOTIFY_DIE
> +	bool
> +	default y
> +

This is all fairly unpleasant.

What architecture is preventing us from using DIE_NMI_POST on all
architectures which support ipmi?  ia64?

It would be better to simply require that all ipmi-using architectures
implement notify_die(DIE_NMI_POST, ...).

