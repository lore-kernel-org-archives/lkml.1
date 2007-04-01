Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXDATGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXDATGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751607AbXDATGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 15:06:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19016 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbXDATGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 15:06:50 -0400
Date: Sun, 1 Apr 2007 12:07:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH 08/16] console-printk-level.diff
Message-Id: <20070401120754.3b619788.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.61.0704012007020.12316@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012007020.12316@yvahk01.tjqt.qr>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007 20:15:27 +0200 (MEST) Jan Engelhardt wrote:

> 
> Allow the printk level to be set using a "conlevel=" parameter.
> (Or is there already a different bootoption that does the same thing?)

Yes, there's "loglevel", as well as
"debug", "quiet", and "ignore_loglevel".


> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
> 
>  printk.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> Index: linux-2.6.21-rc5/kernel/printk.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/kernel/printk.c
> +++ linux-2.6.21-rc5/kernel/printk.c
> @@ -747,6 +747,15 @@ void resume_console(void)
>  }
>  #endif /* CONFIG_DISABLE_CONSOLE_SUSPEND */
>  
> +static __init int set_conlevel(char *str)
> +{
> +	if(*str >= '0' && *str <= '9')
> +		*console_printk = *str - '0';

s/*console_printk/console_loglevel/


> +	return 1;
> +}
> +
> +__setup("conlevel=", set_conlevel);

s/conlevel/loglevel/

> +
>  /**
>   * acquire_console_sem - lock the console system for exclusive use.
>   *

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
