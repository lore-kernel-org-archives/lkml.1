Return-Path: <linux-kernel-owner+w=401wt.eu-S1755352AbYHDMs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbYHDMs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbYHDMsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:48:18 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:43908 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYHDMsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:48:16 -0400
Date: Mon, 4 Aug 2008 14:48:07 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       michael@free-electrons.com, Matt Mackall <mpm@selenic.com>,
       netdev@vger.kernel.org, davem@davemloft.net, akpm@linux-foundation.org
Subject: Re: [patch 4/4] Configure out IGMP support
Message-ID: <20080804144807.6b2374d9@surf>
In-Reply-To: <1217619715.3454.488.camel@pmac.infradead.org>
References: <20080731092703.661994657@free-electrons.com>
	<20080731093221.565015353@free-electrons.com>
	<1217619715.3454.488.camel@pmac.infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Fri, 01 Aug 2008 20:41:55 +0100,
David Woodhouse <dwmw2@infradead.org> a écrit :

> The config option probably lives in net/Kconfig, not init/Kconfig.

Yes, it could. But AFAIK, until now, all CONFIG_EMBEDDED-related
options have been put in init/Kconfig. But if it's preferred, I can of
course change the patch to move the config option to net/Kconfig.

> And please could you make it clear how this interacts with
> IP_MULTICAST?
> 
> We already have a CONFIG_IP_MULTICAST option, for which the help text
> says "For more people, it's safe to say N'. And I think it defaults to
> that too. What more does CONFIG_IGMP remove? It's not made clear by
> the help text.

The interaction of IGMP support with CONFIG_IP_MULTICAST is fairly
unclear to me.

A large portion of igmp.c is already under #ifdef CONFIG_IP_MULTICAST:
all the igmp_*() functions, amongst which is igmp_rcv(), referenced in
igmp_protocol in net/ipv4/af_inet.c, which is compiled-out
when !CONFIG_IP_MULTICAST.

All the proc-related code at the end of the file is only conditionnaly
compiled on CONFIG_PROC_FS, but seems to in fact be only used if both
CONFIG_IP_MULTICAST and CONFIG_PROC_FS are selected:
igmp_mc_proc_init() in net/ipv4/ip_output.c is only called when
CONFIG_IP_MULTICAST and CONFIG_PROC_FS are selected.

Besides that, it's unclear to me why the ip_mc_*() functions are useful
when !CONFIG_IP_MULTICAST, but I'm probably missing something. They are
used to implement setsockopt-operations related to multicast, hooks for
the routing code to handle multicast-related traffic, etc.

Sincerly,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers and embedded Linux development,
consulting, training and support.
http://free-electrons.com
