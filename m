Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYGJLYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYGJLYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYGJLYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:24:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51648 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752345AbYGJLYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:24:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH]xen: fix up config dependencies on PM
Date: Thu, 10 Jul 2008 13:25:42 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <487559AC.1010301@goop.org>
In-Reply-To: <487559AC.1010301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807101325.42586.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 10 of July 2008, Jeremy Fitzhardinge wrote:
> Xen save/restore needs bits of code enabled by PM_SLEEP, and PM_SLEEP
> depends on PM.  So make XEN_SAVE_RESTORE depend on PM and PM_SLEEP
> depend on XEN_SAVE_RESTORE.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

> ---
>  arch/x86/xen/Kconfig |    5 +++++
>  kernel/power/Kconfig |    2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> ===================================================================
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -23,3 +23,8 @@
>           according to the maximum possible memory size of a Xen
>           domain.  This array uses 1 page per gigabyte, so there's no
>           need to be too stingy here.
> +
> +config XEN_SAVE_RESTORE
> +       bool
> +       depends on PM
> +       default y
> \ No newline at end of file
> ===================================================================
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -82,7 +82,7 @@
>  
>  config PM_SLEEP
>  	bool
> -	depends on SUSPEND || HIBERNATION
> +	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
>  	default y
>  
>  config SUSPEND
> 
