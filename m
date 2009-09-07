Return-Path: <linux-kernel-owner+w=401wt.eu-S1758923AbZIGFjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923AbZIGFjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 01:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758829AbZIGFjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 01:39:11 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38787 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758813AbZIGFjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 01:39:10 -0400
Date: Mon, 7 Sep 2009 06:39:14 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: torvalds@linux-foundation.org
cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: [git pull] drm-fixes for final
Message-ID: <alpine.DEB.2.00.0909070638060.29508@skynet.skynet.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull the 'drm-fixes' branch from
ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes

Another radeon KMS fix, it just adds some adds a few necessary registers 
to the command stream checkers and removes one that could let userspace
do bad things.

Dave.

 drivers/gpu/drm/radeon/r300.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_asic.h |    6 ++--
 drivers/gpu/drm/radeon/rs600.c       |   65 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/rs690.c       |   64 ---------------------------------
 drivers/gpu/drm/radeon/rv515.c       |    2 +-
 5 files changed, 70 insertions(+), 69 deletions(-)

commit a54775c8758a754186bc6adbfc518b1e9f8f1e4e
Author: Dave Airlie <airlied@redhat.com>
Date:   Mon Sep 7 15:26:19 2009 +1000

    drm/radeon/kms: add LTE/GTE discard + rv515 two sided stencil register.
    
    This adds some rv350+ register for LTE/GTE discard,
    and enables the rv515 two sided stencil register.
    It also disables the DEPTHXY_OFFSET register which
    can be used to workaround the CS checker.
    Moves rs690 to proper place in rs600 and uses correct
    table on rs600.
    
    Signed-off-by: Dave Airlie <airlied@redhat.com>
