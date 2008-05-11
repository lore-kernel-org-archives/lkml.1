Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbYEKUGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbYEKUGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 16:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759137AbYEKUGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 16:06:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758947AbYEKUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 16:06:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=R/3Dmd7LnTz3iaTNQOn9sQDvxazxZFS3C+oNNjrbFloJ0jprfN/gXTYNbf2DUJQ++0+/358UueJtWmMFGFndAD84M6nHLfoMK6FNpwj0GRx+UbepJuw8FeVYmmjHpyBI60xjTsUqNJa7dxnesnaS4m190geO/ifQsSUJmVfHkfA=
Date: Sun, 11 May 2008 22:05:46 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [PATCH] s390/char/vmlogrdr: module initialization function should
	return negative errors
Message-ID: <20080511200542.GL19058@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/char/vmlogrdr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index d364e0b..e848734 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -858,7 +858,7 @@ static int __init vmlogrdr_init(void)
 	for (i=0; i < MAXMINOR; ++i ) {
 		sys_ser[i].buffer = (char *) get_zeroed_page(GFP_KERNEL);
 		if (!sys_ser[i].buffer) {
-			rc = ENOMEM;
+			rc = -ENOMEM;
 			break;
 		}
 		sys_ser[i].current_position = sys_ser[i].buffer;
-- 
