Return-Path: <linux-kernel-owner+w=401wt.eu-S933809AbZJIRm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933809AbZJIRm4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 13:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933694AbZJIRmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 13:42:52 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:19807 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591AbZJIRmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 13:42:46 -0400
Authentication-Results: sj-iport-2.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAE8Sz0qrR7Hu/2dsb2JhbADCfphFhCwE
X-IronPort-AV: E=Sophos;i="4.44,533,1249257600"; 
   d="scan'208";a="213099224"
From: Roland Dreier <rdreier@cisco.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Bill Pemberton <wfp5p@virginia.edu>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Staging: comedi: Add include of <linux/sched.h> to fix build
X-Message-Flag: Warning: May contain useful information
Date: Fri, 09 Oct 2009 10:42:09 -0700
Message-ID: <adamy40jwge.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Oct 2009 17:42:09.0893 (UTC) FILETIME=[D3B4F150:01CA4907]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a99bbaf5 ("headers: remove sched.h from poll.h") removed the
implicit include of <linux/sched.h> via <linux/poll.h>, and broke the
comedi build with errors like:

    drivers/staging/comedi/drivers/serial2002.c:201: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)

Explicitly include <linux/sched.h> to fix this.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
---
 drivers/staging/comedi/drivers/serial2002.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/comedi/drivers/serial2002.c b/drivers/staging/comedi/drivers/serial2002.c
index a219679..3b706ca 100644
--- a/drivers/staging/comedi/drivers/serial2002.c
+++ b/drivers/staging/comedi/drivers/serial2002.c
@@ -40,6 +40,7 @@ Status: in development
 #include <asm/ioctls.h>
 #include <linux/serial.h>
 #include <linux/poll.h>
+#include <linux/sched.h>
 
 /*
  * Board descriptions for two imaginary boards.  Describing the
