Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYIXXeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYIXXeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYIXXeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:34:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49732
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752201AbYIXXeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:34:25 -0400
Date: Wed, 24 Sep 2008 16:34:13 -0700 (PDT)
Message-Id: <20080924.163413.119422112.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Networking
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ This should be my last set of bug fixes before leaving for the
  netfilter workshop in Paris. ]

1) ATH9K interrupt storm fix.  Statistic interrupts are not handled fully,
   so the interrupt doesn't get cleared.  The condition that isn't handled
   happens after about 7 hours of operation.

   The fix is to not enable these interrupts, as they aren't even really
   needed as of yet.

2) Three bluetooth btusb driver fixes to deal with some regression list
   entries:
   1) A flag bit gets set in the wrong set of flags :-)  Also, the
      URB is queued to the wrong anchor.
   2) A quirk list entry is needed for newer MacBooks
   3) The INTF and ISOC interfaces need to be bound together to prevent
      misbehavior when only one of them is disconneted.

3) And ipv6 netfilter fix from Yasuyuki Kozakai.  IP6T_OPTS_NSTRICT is
   silently accepted (with a pr_debug() message), even though this
   functionality is currently not even implemented.  We need to reject
   this as the user will think the successful rule addition will mean
   that the iptables rule will behave as requested, when in fact it
   will not.

Please pull, thanks a lot!

The following changes since commit 4c07ab0fe4b4eaa0fc31f640ca65da7c173f5043:
  David S. Miller (1):
        Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

David S. Miller (1):
      Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

Luis R. Rodriguez (1):
      ath9k: disable MIB interrupts to fix interrupt storm

Marcel Holtmann (3):
      [Bluetooth] Fix I/O errors on MacBooks with Broadcom chips
      [Bluetooth] Fix wrong URB handling of btusb driver
      [Bluetooth] Fix USB disconnect handling of btusb driver

Yasuyuki Kozakai (1):
      netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion

 drivers/bluetooth/btusb.c         |   28 ++++++++++++++++++++++------
 drivers/net/wireless/ath9k/core.c |    7 +++++++
 net/ipv6/netfilter/ip6t_hbh.c     |    8 ++++++--
 3 files changed, 35 insertions(+), 8 deletions(-)
