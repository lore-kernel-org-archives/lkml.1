Return-Path: <linux-kernel-owner+w=401wt.eu-S1753253AbXLEV5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbXLEV5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbXLEV4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:56:53 -0500
Received: from main.gmane.org ([80.91.229.2]:38294 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbXLEV4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:56:53 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: New Address Family: Inter Process Networking (IPN)
Date: Wed, 5 Dec 2007 16:55:52 -0500
Organization: Linux Foundation
Message-ID: <20071205165552.3fc96dae@shemminger-laptop>
References: <20071205164055.GA2082@cs.unibo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 63.118.136.215
In-Reply-To: <20071205164055.GA2082@cs.unibo.it>
X-Newsreader: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2007 17:40:55 +0100
renzo@cs.unibo.it (Renzo Davoli) wrote:

> 
> WHAT WE NEED FROM THE LINUX KERNEL COMMUNITY
> --------------------------------------------
> 0- (Constructive) comments.
> 
> 1- The "official" assignment of an Address Family.
> (It is enough for everything but interface grabbing, see 2)
> 
> in include/linux/net.h:
> - #define NPROTO          34              /* should be enough for now..  */
> + #define NPROTO          35              /* should be enough for now..  */
> 
> in include/linux/socket.h
> + #define AF_IPN 34
> + #define PF_IPN AF_IPN
> - #define AF_MAX          34      /* For now.. */
> + #define AF_MAX          35      /* For now.. */
> 
> This seems to be quite simple.
> 
> 2- Another "grabbing hook" for interfaces (like the ones already
> existing for the kernel bridge and for the macvlan).
> 
> In include/linux/netdevice.h:
> among the fields of struct net_device:
> 
>         /* bridge stuff */
> 	struct net_bridge_port  *br_port;
> 	/* macvlan */
> 	struct macvlan_port     *macvlan_port;
> +        /* ipn */
> +        struct ipn_node        *ipn_port;
> 		 
> 	/* class/net/name entry */
> 	struct device           dev;
> 
> In net/core/dev.c, we need another section for grabbing packets....
> like the ones defined for CONFIG_BRIDGE and CONFIG_MACVLAN.
> I can write the patch (it needs just tens of minutes of cut&paste).
> We are studying some way to register/deregister grabbing services,
> I feel this would be the cleanest way. 
> 
> WHERE?
> ------
> There is an experimental version in the VDE svn tree.
> http://sourceforge.net/projects/vde
>

Post complete source code for kernel part to netdev@vger.kernel.org.
If you want the hooks, you need to include the full source code for inclusion
in mainline. All the Documentation/SubmittingPatches rules apply;
you can't just ask for "facilitators" and expect to keep your stuff out of tree.

