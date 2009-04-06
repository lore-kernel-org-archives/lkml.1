Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZDFVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZDFVgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbZDFVgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:36:14 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:41207 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbZDFVgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:36:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=T/9VuTwBj5O1sTcJgpApLZxPvsY4256D/+9voxakjEhAsMBlcQZ+DQn7SsaD2sw3k2
         24Au+hEIYf+IiKWkfVG0x1n+ecPFSsUml2i7X30kAN0UZ38W+9JEhXxxK+mU53x6jhlM
         muSSVITbsaTRRv8mC/NioLPq5Q30fsvCmZPqw=
Date: Tue, 7 Apr 2009 01:35:56 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, neilb@suse.de, jens.axboe@oracle.com,
       torvalds@linux-foundation.org
Subject: [PATCH] md/raid1: fix build breakage
Message-ID: <20090406213556.GA29973@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
drivers/md/raid1.c: In function 'raid1_congested':
drivers/md/raid1.c:589: error: 'BDI_write_congested' undeclared

BDI_write_congested was changed in 1faa16d2
(block: change the request allocation/congestion logic to be sync/async
based)

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f2247b0..274b491 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -586,7 +586,7 @@ static int raid1_congested(void *data, int bits)
 			/* Note the '|| 1' - when read_balance prefers
 			 * non-congested targets, it can be removed
 			 */
-			if ((bits & (1<<BDI_write_congested)) || 1)
+			if ((bits & (1<<BDI_async_congested)) || 1)
 				ret |= bdi_congested(&q->backing_dev_info, bits);
 			else
 				ret &= bdi_congested(&q->backing_dev_info, bits);
