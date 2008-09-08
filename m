Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYIHU7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYIHU7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 16:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbYIHU7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 16:59:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60298
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753645AbYIHU7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 16:59:08 -0400
Date: Mon, 08 Sep 2008 13:59:01 -0700 (PDT)
Message-Id: <20080908.135901.206413625.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Two SMP fixes for sparc64:

1) Conversion to generic SMP call function helpers didn't update the
   locking.  The sparc64 code was still using it's local "call lock"
   in it's cpu hotplug code, yet that isn't used for smp_call_function()
   et al. any longer.  Fix to use the locking interface exposed by
   the generic code.

2) Bug fix from Paul McKenney so that the online cpu map is cleared
   at the correct moment during cpu hotplug.  Otherwise an offline
   CPU can receive an interrupt and lots of code does not like that.

Please pull, thanks a lot.

The following changes since commit dbb8c35d9063fe233626865cc836fbc102fa083b:
  David S. Miller (1):
        sparc64: setup_valid_addr_bitmap_from_pavail() should be __init

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

David S. Miller (1):
      sparc64: Fix IPI call locking.

Paul E. McKenney (1):
      sparc64: Prevent sparc64 from invoking irq handlers on offline CPUs

 arch/sparc64/kernel/smp.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)
