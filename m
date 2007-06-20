Return-Path: <linux-kernel-owner+w=401wt.eu-S1761985AbXFTD4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761985AbXFTD4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 23:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759637AbXFTDz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 23:55:59 -0400
Received: from gate.crashing.org ([63.228.1.57]:57786 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071AbXFTDz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 23:55:59 -0400
Date: Tue, 19 Jun 2007 22:55:47 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Linus Torvalds <torvalds@osdl.org>
cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Please pull from 'for_linus' branch
Message-ID: <Pine.LNX.4.64.0706192241550.13170@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from 'for_linus' branch at

	master.kernel.org:/pub/scm/linux/kernel/git/galak/powerpc.git for_linus

To get a fix for 2.6.22 to the rheap allocator that was causing multiple
instances of the UCC ethernet driver to fail because it was running out of
memory due to wasting space for aligned requests.

Thanks,
Kumar.

 arch/powerpc/lib/rheap.c |   48 ++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

commit 7c8545e98468c53809fc06788a3b9a34dff05240
Author: Li Yang <leoli@freescale.com>
Date:   Mon Jun 18 19:29:21 2007 +0800

    [POWERPC] rheap - eliminates internal fragments caused by alignment

    The patch adds fragments caused by rh_alloc_align() back to free list, instead
    of allocating the whole chunk of memory.  This will greatly improve memory
    utilization managed by rheap.

    It solves MURAM not enough problem with 3 UCCs enabled on MPC8323.

    Signed-off-by: Li Yang <leoli@freescale.com>
    Acked-by: Joakim Tjernlund <joakim.tjernlund@transmode.se>
    Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
