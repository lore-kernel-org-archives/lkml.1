Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYHLUrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYHLUrK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 16:47:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHLUq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 16:46:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYHLUq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 16:46:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [PATCH 2/5] Container Freezer: Make refrigerator always available
Date: Tue, 12 Aug 2008 22:49:26 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Cedric Le Goater <clg@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
References: <20080811235323.872291138@us.ibm.com> <20080811235324.661871296@us.ibm.com>
In-Reply-To: <20080811235324.661871296@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808122249.27553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Matt Helsley wrote:
> Now that the TIF_FREEZE flag is available in all architectures,
> extract the refrigerator() and freeze_task() from kernel/power/process.c
> and make it available to all.
> 
> The refrigerator() can now be used in a control group subsystem
> implementing a control group freezer.
> 
> Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
> Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
> Acked-by: Serge E. Hallyn <serue@us.ibm.com>
> Tested-by: Matt Helsley <matthltc@us.ibm.com>

Your Signed-off-by implies your Tested-by (at least it should ;-)).

> ---
[--snip--]
> Index: linux-2.6.27-rc1-mm1/kernel/power/Kconfig
> ===================================================================
> --- linux-2.6.27-rc1-mm1.orig/kernel/power/Kconfig
> +++ linux-2.6.27-rc1-mm1/kernel/power/Kconfig
> @@ -85,6 +85,9 @@ config PM_SLEEP
>  	depends on SUSPEND || HIBERNATION || XEN_SAVE_RESTORE
>  	default y
>  
> +config FREEZER
> +	def_bool PM_SLEEP
> +

I'd still prefer this to go into a Kconfig in the parent directory (ie. where
freezer.c and the Makefile building it are located).  Otherwise it's guaranteed
to confuse someone.

>  config SUSPEND
>  	bool "Suspend to RAM and standby"
>  	depends on PM && ARCH_SUSPEND_POSSIBLE
> 


