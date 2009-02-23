Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZBWXqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZBWXqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:46:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZBWXql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:46:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41530
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbZBWXqk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:46:40 -0500
Date: Mon, 23 Feb 2009 15:46:21 -0800 (PST)
Message-Id: <20090223.154621.08279126.davem@davemloft.net>
To: linux@kolla.no
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: PROBLEM: IPv6 autoconf/accept_ra default values
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.0902231319380.14151@halbrend.uninett.no>
References: <alpine.LNX.2.00.0902231319380.14151@halbrend.uninett.no>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kolbjørn Barmen <linux@kolla.no>
Date: Mon, 23 Feb 2009 15:42:41 +0100 (CET)

> 
> Hello
> 
> 1. Summary of problem

You'll get more replies if you contact the networking developers
at netdev@vger.kernel.org

> autoconfig and accept_ra is by default on (by the way of forwarning) -
> this is very problematic in many ways.
> 
> 2. Full description of the problem/report:
> 
> * if you want staticly only configured addresses/gateway (which is
>   something you just might want for server machines for example) you need
>   to change the sysctl parameters before the interface is brought up. 
>   (yes, I want staticly, and only staticly configured addresses, dont get
>   me started on why - keywords: source address, dns, ssl, access control)
> 
> * to change the default values, ipv6 module needs to be loaded, in many
>   distros this leads to race conditions, especially in these "autodetect
>   hardware and bring up everything magically" days :)
> 
> * if you netboot with ipv6 enabled kernel, interface will pick up ipv6
>   autoconf no matter, so you need to remove addresses and routes manually
>   after boot. As far as I know there is now kernel parameters to tell
>   kernel to not autoconf ipv6. I admit I have not tested out whether it's
>   possible to use ipv6-addresses as kernel parameters at all.
> 
> * ipv6 kernel module has no load paramters as far as I can tell?
> 
> * changing net.ipv6.conf.all.* and net.ipv6.conf.default.* dont work as
>   intended? I'm really not sure how this is meant to work, but intuitively
>   I would think that "...all.*" would affect all interfaces present, and
>   "...*.default.*" would set the default values for "future" interfaces.
>   Maybe I'm wrong? Look further down...
> 
> 3. Keywords
>    ipv6, forwarding, autoconf, accept_ra
> 
> 4. Kernel version (from /proc/version):
>    This goes accross all 2.6 kernels as far as I can tell, no matter what
>    distro.
> 
> 5. Output of Oops.. message
>    No oops so far :)
> 
> 6. A small shell script or example program which triggers the problem 
>    
>    root:~# sysctl net.ipv6.conf.all.accept_ra
>    net.ipv6.conf.all.accept_ra = 1
>    root:~# sysctl -w net.ipv6.conf.all.accept_ra=0
>    net.ipv6.conf.all.accept_ra = 0
>    root:~# sysctl net.ipv6.conf.eth0.accept_ra
>    net.ipv6.conf.all.accept_ra = 1
>    
> I suppose the above is fals behaviour? I'm really not sure, but if this is
> not a bug, then I fail to see the purpose of the "...all.*" and
> "...default.*" sysctl parameters. From the documentation
> (networking/ip-sysctl.txt) I get the impression that the above behaviour
> is wrong:
> 
> --- 
> conf/default/*:
>         Change the interface-specific default settings.
> 
> conf/all/*:
>         Change all the interface-specific settings.
> 
>         [XXX:  Other special features than forwarding?]
> ---
> 
> Looks like this is unclear for more than just me :)
> 
> 
> My personal oppinion is that anything ipv6 autoconfig/accept_ra should be
> default _off_, since this simplifies all the above mentioned issues, and
> it is incredibly easy to turn on again with systcl if people want it.
> It is much easier to enable ipv6 automagic than to disable it.
> At least there should be kernel/module parameter to set default behaviour.
> 
> Part of the problem with deploying IPv6 is due to "magic" like this, all
> the autoconfig/router announcement magic looks very well on paper and in
> theory, but out in the field it quickly leads to loads of totally
> unnecessary extra work, work that could easily be avoided if default
> behaviour was to have it off. It should be in the interest of IPv6
> advocates to support a "soft" transition from IPv4-only to dual-stack,
> fencing off unwanted "magic" only adds to the frustration for those who
> actually try to deploy it.
> 
> What do you think?
> 
> If there already is a simple stright forward solution, then I apologize
> for this rant - please enlighten me :)
> 
> -- kolla
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
