Return-Path: <linux-kernel-owner+w=401wt.eu-S1758988AbYDZIrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758988AbYDZIrS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 04:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYDZIrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 04:47:09 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59928 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbYDZIrI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 04:47:08 -0400
Date: Sat, 26 Apr 2008 09:47:06 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [git tree] agp patches for 2.6.26-rc1
Message-ID: <alpine.DEB.0.82.0804260946300.12688@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'agp-patches' branch from
git://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-patches

Dave.

 drivers/char/agp/amd-k7-agp.c |    3 ++-
 drivers/char/agp/frontend.c   |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

commit 09aa356b5584090aab6810ec8002936d710cd4ac
Author: Mathieu Segaud <mathieu.segaud@regala.cx>
Date:   Fri Apr 18 13:29:38 2008 -0700

    agp: convert drivers/char/agp/frontend.c to use unlocked_ioctl
    
    As of now, agp_compat_ioctl already runs without the BKL.  Mutual exclusion
    is enforced by agp_fe.agp_mutex in agp_ioctl() and agp_compat_ioctl().
    Apply the same locking rationale to the two functions allowing BKL cleanup.
    
    Signed-off-by: Mathieu Segaud <mathieu.segaud@regala.cx>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>

commit 4ab92bcf773e7b9e1367897047d5fa4d151d9e90
Author: Harvey Harrison <harvey.harrison@gmail.com>
Date:   Sat Apr 26 18:38:04 2008 +1000

    agp: fix shadowed variable warning in amd-k7-agp.c
    
    Introduced between 2.6.25-rc2 and -rc3
    drivers/char/agp/amd-k7-agp.c:439:6: warning: symbol 'cap_ptr' shadows an
    earlier one
    drivers/char/agp/amd-k7-agp.c:414:5: originally declared here
    
    cap_ptr is never used again in this function, don't bother redeclaring.
    
    Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Dave Airlie <airlied@linux.ie>
