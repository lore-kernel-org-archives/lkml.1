Return-Path: <linux-kernel-owner+w=401wt.eu-S1757650AbXIYQQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757650AbXIYQQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 12:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbXIYQQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 12:16:43 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755286AbXIYQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 12:16:42 -0400
Date: Tue, 25 Sep 2007 09:16:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, eugene.surovegin@zultys.com,
       netdev@vger.kernel.org
Subject: Re: 2.6.23-rc8-mm1 - drivers/net/ibm_newemac/mal - broken
Message-Id: <20070925091613.44042909.akpm@linux-foundation.org>
In-Reply-To: <46F904E6.40601@linux.vnet.ibm.com>
References: <20070925014625.3cd5f896.akpm@linux-foundation.org>
	<46F904E6.40601@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 18:23:58 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> The drivers/net/ibm_newemac/mal seems to be broken, which stop with
> build error

(please cc netdev@vger.kernel.org on networking things)

> CC      drivers/net/ibm_newemac/mal.o
> drivers/net/ibm_newemac/mal.c: In function ‘mal_schedule_poll’:
> drivers/net/ibm_newemac/mal.c:238: error: too few arguments to function ‘netif_rx_schedule_prep’
> drivers/net/ibm_newemac/mal.c:238: error: too few arguments to function ‘netif_rx_schedule_prep’
> drivers/net/ibm_newemac/mal.c:238: error: too few arguments to function ‘netif_rx_schedule_prep’
> drivers/net/ibm_newemac/mal.c:241: error: too few arguments to function ‘__netif_rx_schedule’
> drivers/net/ibm_newemac/mal.c: In function ‘mal_poll_disable’:
> drivers/net/ibm_newemac/mal.c:321: error: ‘__LINK_STATE_RX_SCHED’ undeclared (first use in this function)
> drivers/net/ibm_newemac/mal.c:321: error: (Each undeclared identifier is reported only once
> drivers/net/ibm_newemac/mal.c:321: error: for each function it appears in.)
> drivers/net/ibm_newemac/mal.c: In function ‘mal_poll’:
> drivers/net/ibm_newemac/mal.c:337: error: ‘struct net_device’ has no member named ‘quota’
> drivers/net/ibm_newemac/mal.c:337: warning: type defaults to ‘int’ in declaration of ‘_x’
> drivers/net/ibm_newemac/mal.c:337: error: ‘struct net_device’ has no member named ‘quota’
> drivers/net/ibm_newemac/mal.c:375: error: too few arguments to function ‘__netif_rx_complete’
> drivers/net/ibm_newemac/mal.c:390: warning: passing argument 2 of ‘netif_rx_reschedule’ makes pointer from integer without a cast
> drivers/net/ibm_newemac/mal.c:404: error: ‘struct net_device’ has no member named ‘quota’
> drivers/net/ibm_newemac/mal.c: In function ‘mal_probe’:
> drivers/net/ibm_newemac/mal.c:542: error: ‘struct net_device’ has no member named ‘weight’
> drivers/net/ibm_newemac/mal.c:543: error: ‘struct net_device’ has no member named ‘poll’
> drivers/net/ibm_newemac/mal.c: In function ‘mal_remove’:
> drivers/net/ibm_newemac/mal.c:660: error: implicit declaration of function ‘netif_poll_disable’
> make[3]: *** [drivers/net/ibm_newemac/mal.o] Error 1
> make[2]: *** [drivers/net/ibm_newemac] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

Yes, there's been a lot of breakage in netdev land:

git-net-fix-macec.patch
git-net-sky2-fixups.patch
git-net-fix-wireless-kconfig.patch
git-net-fix-spidernet-build.patch
git-net-sctp-build-fix.patch
spider_net_ethtool-keep-up-with-recent-netdev-stats-changes.patch
pasemi_mac-build-fix-after-recent-netdev-stats.patch
git-net-fix-pasemi_mac.patch
make-mv643xx_ethc-build-again.patch

but we're getting there.  It looks like ibmn_newemac is more busted than
most...
