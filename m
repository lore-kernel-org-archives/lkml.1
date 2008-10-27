Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYJ0G05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYJ0G05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 02:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbYJ0G0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 02:26:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34346
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbYJ0G0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 02:26:49 -0400
Date: Sun, 26 Oct 2008 23:26:26 -0700 (PDT)
Message-Id: <20081026.232626.97216182.davem@davemloft.net>
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


Several bug fixes:

1) Skb ->when timestamp setting for syncookies got messed up
   by TCP option building engine changes in 2.6.27.  Fix from
   Florian Westphal

   I'll submit this thusly to -stable as well.

2) Couple places trying to pass sk_buff to kfree() instead of
   kfree_skb().  Fixed by Sergio Luis

3) Two fixes for the new phonet protocol layer from Remi
   Denis-Courmont

Please pull, thanks a lot.

The following changes since commit f8d56f1771e4867acc461146764b4feeb5245669:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://neil.brown.name/md

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

Florian Westphal (1):
      syncookies: fix inclusion of tcp options in syn-ack

Remi Denis-Courmont (2):
      Phonet: include generic link-layer header size in MAX_PHONET_HEADER
      Phonet: do not reply to indication reset packets

Sergio Luis (2):
      btsdio: free sk_buff with kfree_skb
      libertas: free sk_buff with kfree_skb

 drivers/bluetooth/btsdio.c         |    2 +-
 drivers/net/wireless/libertas/rx.c |    2 +-
 include/linux/phonet.h             |    1 +
 include/net/phonet/phonet.h        |    2 +-
 net/ipv4/tcp_output.c              |   10 +++++-----
 net/phonet/af_phonet.c             |    5 ++++-
 6 files changed, 13 insertions(+), 9 deletions(-)
