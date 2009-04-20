Return-Path: <linux-kernel-owner+w=401wt.eu-S1752101AbZDTABR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbZDTABR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 20:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbZDTABA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 20:01:00 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48184 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113AbZDTABA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 20:01:00 -0400
Date: Sun, 19 Apr 2009 20:00:51 -0400
From: Andres Salomon <dilinger@queued.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, david-b@pacbell.net, jordan@cosmicpenguin.net,
       katzj@redhat.com, tiwai@suse.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cs553x: fix build dependency problems
Message-ID: <20090419200051.235089e9@ephemeral>
In-Reply-To: <49EA77DE.7040700@oracle.com>
References: <200904062355.n36NtLTf018342@imap1.linux-foundation.org>
	<49DFA576.6040005@oracle.com>
	<20090412215203.45e2a876@ephemeral>
	<49E2BEE2.8070305@oracle.com>
	<49EA77DE.7040700@oracle.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Apr 2009 18:01:18 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Andres, how does this look to you?
> 
> It fixes the problems that I know about.
> 
> 
> 

This may be okay as a separate patch, but doesn't really fix the problem.
cs553x-gpio isn't just for OLPC, it can be used by plain Geodes.  I've
lost track of the state of the patches at this point, but the solution
would be to simply have CONFIG_GPIO_CS553X depend upon PCI.




> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix multiple build errors due to cs553x-gpio using GPIO APIs
> and using PCI APIs.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  arch/x86/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- mmotm-2009-0417-1519.orig/arch/x86/Kconfig
> +++ mmotm-2009-0417-1519/arch/x86/Kconfig
> @@ -1969,7 +1969,8 @@ config GEODE_MFGPT_TIMER
>  
>  config OLPC
>  	bool "One Laptop Per Child support"
> -	select GPIO_CS553X
> +	select GPIO_CS553X if PCI
> +	select GPIOLIB if PCI
>  	default n
>  	---help---
>  	  Add support for detecting the unique features of the OLPC
