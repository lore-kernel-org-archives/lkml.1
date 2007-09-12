Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbXILTTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbXILTTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbXILTTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 15:19:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:64224 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXILTTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 15:19:43 -0400
Message-ID: <46E83B67.1050106@windriver.com>
Date: Wed, 12 Sep 2007 14:17:59 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Matt Mackall <mpm@selenic.com>, Jiri Slaby <jirislaby@gmail.com>,
       kgdb-bugreport@lists.sourceforge.net, amitkale@linsyssoft.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Kgdb-bugreport] [PATCH -mm v2] 2.6.23-rc4-mm1: kgdboe link errors
References: <46E7B1EA.2040009@gmail.com>	<20070912101537.129d10c7.randy.dunlap@oracle.com>	<20070912181512.GQ4219@waste.org> <20070912112252.7658b7db.randy.dunlap@oracle.com>
In-Reply-To: <20070912112252.7658b7db.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Sep 2007 19:18:28.0742 (UTC) FILETIME=[B30CD260:01C7F571]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy,

This patch is fine, and I am committing it to the for_mm kgdb tree.

I am also adding the "depends on NET" to the KGDBOE_NOMODULE section, 
which would otherwise to a select on KGDBOE. We have to cover the case 
for KGDB as a module and not as a module.

Thanks,
Jason.

Randy Dunlap wrote:
> On Wed, 12 Sep 2007 13:15:12 -0500 Matt Mackall wrote:
>
>   
>> NETCONSOLE shouldn't be necessary. Otherwise this looks ok to my
>> kconfig-addled brain.
>>     
>
> Correct.  Patch corrected.  Thanks.
>
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Fix kgdb build problems:
>   Building modules, stage 2.
> ERROR: "netpoll_cleanup" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_setup" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_parse_options" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_poll" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_send_udp" [drivers/net/kgdboe.ko] undefined!
> ERROR: "netpoll_set_trap" [drivers/net/kgdboe.ko] undefined!
> make[1]: *** [__modpost] Error 1
>
>
> Add 'select' for net-poll related config symbols, but
> make KGDBOE 'depend on' NET.  We don't want to 'select' CONFIG_NET,
> but if it is already enabled, the 'select's will enable the rest
> of the needed interfaces.
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  lib/Kconfig.kgdb |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> --- linux-2.6.23-rc4-mm1.orig/lib/Kconfig.kgdb
> +++ linux-2.6.23-rc4-mm1/lib/Kconfig.kgdb
> @@ -174,9 +174,10 @@ endchoice
>  
>  config KGDBOE
>  	tristate "KGDB: On ethernet" if !KGDBOE_NOMODULE
> -	depends on m && KGDB
> +	depends on m && KGDB && NET
>  	select NETPOLL
>  	select NETPOLL_TRAP
> +	select NET_POLL_CONTROLLER
>  	help
>  	  Uses the NETPOLL API to communicate with the host GDB via UDP.
>  	  In order for this to work, the ethernet interface specified must
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2005.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Kgdb-bugreport mailing list
> Kgdb-bugreport@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/kgdb-bugreport
>   

