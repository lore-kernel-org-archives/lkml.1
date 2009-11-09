Return-Path: <linux-kernel-owner+w=401wt.eu-S1751107AbZKIFaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbZKIFaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 00:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750771AbZKIFaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 00:30:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34336
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750739AbZKIFa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 00:30:29 -0500
Date: Sun, 08 Nov 2009 21:30:55 -0800 (PST)
Message-Id: <20091108.213055.54434626.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: IDE
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The revert we thought we didn't need, we really do need still, even
with Bart Z.'s fix.

The issue is that we are doing these PIO setting calls before we did
the device probe and therefore we don't yet know the media type.

Yet the ->set_pio_mode() of some drivers key off of the media type to
determine whether to turn prefetching etc. on so it can't possibly
work properly.

Please pull, thanks!

The following changes since commit 7c9abfb884b8737f0afdc8a88bcea77526f0da87:
  Linus Torvalds (1):
        Merge branch 'kvm-updates/2.6.32' of git://git.kernel.org/pub/scm/virt/kvm/kvm

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/ide-2.6.git master

David S. Miller (1):
      Revert "ide: try to use PIO Mode 0 during probe if possible"

 drivers/ide/ide-probe.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)
