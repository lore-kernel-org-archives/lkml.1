Return-Path: <linux-kernel-owner+w=401wt.eu-S1751476AbZKRLSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476AbZKRLSH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbZKRLSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:18:06 -0500
Received: from smtp4.adam.net.au ([202.136.110.247]:45843 "EHLO
	smtp4.adam.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKRLSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:18:05 -0500
X-Greylist: delayed 8108 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Nov 2009 06:18:05 EST
Date: Wed, 18 Nov 2009 19:31:16 +1030
From: Mark Smith <lk-netdev@lk-netdev.nosense.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 0/3] macvlan: add vepa and bridge mode
Message-ID: <20091118193116.76881dd9@opy.nosense.org>
In-Reply-To: <1258497551-25959-1-git-send-email-arnd@arndb.de>
References: <1258497551-25959-1-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.3; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Nov 2009 22:39:07 +0000
Arnd Bergmann <arnd@arndb.de> wrote:

> This is based on an earlier patch from Eric Biederman adding
> forwarding between macvlans. I extended his approach to
> allow the administrator to choose the mode for each macvlan,
> and to implement a functional VEPA between macvlan.
> 
> Still missing from this is support for communication between
> the lower device that the macvlans are based on. This would
> be extremely useful but as others have found out before me
> requires significant changes not only to macvlan but also
> to the common transmit path.

If this means that the "children" macvlans can't communicate with their
"parent" interface as though they were all attached to the same virtual
ethernet segment, I think that is a reasonable limitation. On other
networking equipment I've used, the moment "sub-interfaces"
are created, their parent interface can't be used for any
communications, only for setting link related parameters e.g. for
ethernet interfaces, speed and duplex etc.

> 
> I've seen one panic during testing this that I still need
> to track down, but it generally does what is advertised.
> I've tested VEPA operation with the hairpin support
> added to the bridge driver by Anna Fischer.
> 
> My current plan is to submit this for inclusion in 2.6.33
> when people are happy with it and I tracked down any
> remaining bugs, and possibly to do the communication with
> the lower device one release later.
> 
> 	Arnd <><
> 
> ---
> 
> Arnd Bergmann (3):
>   macvlan: implement VEPA and private mode
>   macvlan: export macvlan mode through netlink
>   iplink: add macvlan options for bridge mode
> 
> Eric Biederman (1):
>   macvlan: Reflect macvlan packets meant for other macvlan devices
> 
>  linux/drivers/net/macvlan.c   |  170 +++++++++++++++++++++++++++++++++-----
>  linux/include/linux/if_link.h |   15 +++
>  2 files changed, 161 insertions(+), 24 deletions(-)
> 
>  iproute2/include/linux/if_link.h |   15 +++
>  iproute2/ip/Makefile             |    3 +-
>  iproute2/ip/iplink_macvlan.c     |   93 ++++++++++++++++++
>  3 files changed, 110 insertions(+), 1 deletions(-)
>  create mode 100644 ip/iplink_macvlan.c
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
