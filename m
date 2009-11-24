Return-Path: <linux-kernel-owner+w=401wt.eu-S1757587AbZKXA44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbZKXA44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 19:56:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZKXA4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 19:56:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:58737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZKXA4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 19:56:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Patrick McHardy <kaber@trash.net>,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv2 0/4] macvlan: add vepa and bridge mode
Date: Tue, 24 Nov 2009 00:56:02 +0000
Message-Id: <1259024166-28158-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
X-Provags-ID: V01U2FsdGVkX1+vV3BdgpLqQ3jy4UgR9ssM+S1aM3LVTbdH2fK
 4L7QaVban7KWLeCpdSKr4uqsZU+fzRzkv0wGp2UZdS4xszG9HI
 pYY9xPUEYiIkV9/4cEJPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Second version, all feedback so far addressed, thanks for the
help and interest!

The patch to iproute2 has not changed, so I'm not including
it this time. Patch 4/4 (the netlink interface) is basically
unchanged as well but included for completeness.

The other changes have moved forward a bit, to the point where
I find them a lot cleaner and am more confident in the code
being ready for inclusion. The implementation hardly resembles
Erics original patch now, so I've dropped his signed-off-by.

Please take a look and ack if you are happy so we can get it
into 2.6.33.

---

Version 1 description:
This is based on an earlier patch from Eric Biederman adding
forwarding between macvlans. I extended his approach to
allow the administrator to choose the mode for each macvlan,
and to implement a functional VEPA between macvlan.

Still missing from this is support for communication between
the lower device that the macvlans are based on. This would
be extremely useful but as others have found out before me
requires significant changes not only to macvlan but also
to the common transmit path.

I've tested VEPA operation with the hairpin support
added to the bridge driver by Anna Fischer.

        Arnd <><

Arnd Bergmann (4):
  veth: move loopback logic to common location
  macvlan: cleanup rx statistics
  macvlan: implement bridge, VEPA and private mode
  macvlan: export macvlan mode through netlink

 drivers/net/macvlan.c     |  183 ++++++++++++++++++++++++++++++++++++---------
 drivers/net/veth.c        |   17 +----
 include/linux/if_link.h   |   15 ++++
 include/linux/netdevice.h |    2 +
 net/core/dev.c            |   36 +++++++++
 5 files changed, 204 insertions(+), 49 deletions(-)

