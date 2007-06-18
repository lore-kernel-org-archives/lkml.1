Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbXFREZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbXFREZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751984AbXFREZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:25:32 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45691 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbXFREZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:25:31 -0400
Date: Sun, 17 Jun 2007 21:26:01 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] blink: Only blink when parameter is set
Message-Id: <20070617212601.38f952fe.randy.dunlap@oracle.com>
In-Reply-To: <20070617083904.GC4496@suse.de>
References: <20070617083904.GC4496@suse.de>
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

On Sun, 17 Jun 2007 10:39:04 +0200 Bernhard Walle wrote:

> This patch in the blink driver changes the module to only blink when
> the parameter 'blink' is set to true. This is to allow the module to
> be compiled in the kernel and not as module.
> 
> As the blink module was initially written for kdump, and as the kernel
> is relocatable on lots of architectures, there's no need to compile a
> separate kdump kernel. The blinking can now enabled via the boot
> command line for the kdump kernel when necessary.
> 
> The patch also adds some author/license information and marks the init
> function as '__init'.
> 
> Signed-off-by: Bernhard Walle <bwalle@suse.de>
> 
> ---
>  drivers/misc/blink.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> --- a/drivers/misc/blink.c
> +++ b/drivers/misc/blink.c
> @@ -3,6 +3,10 @@
>  #include <linux/timer.h>
>  #include <linux/jiffies.h>
>  
> +static int blink = 0;

no need to init to 0.

> +module_param(blink, bool, S_IRUGO);
> +MODULE_PARM_DESC(blink, "Enable blinking (without that, the module does nothing)\n");

unneeded "\n"

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
