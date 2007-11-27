Return-Path: <linux-kernel-owner+w=401wt.eu-S1759476AbXK0Q3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759476AbXK0Q3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758972AbXK0Q3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:29:25 -0500
Received: from mtagate2.de.ibm.com ([195.212.29.151]:38894 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183AbXK0Q3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:29:22 -0500
Message-Id: <20071127162919.848871022@de.ibm.com>
References: <20071127162210.262064983@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 27 Nov 2007 17:22:12 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 2/4] cio: add missing reprobe loop end statement
Content-Disposition: inline; filename=002-cio-reprobe.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Add loop end statement to prevent looping over empty subchannel sets.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/css.c |    1 +
 1 file changed, 1 insertion(+)

Index: quilt-2.6/drivers/s390/cio/css.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/css.c
+++ quilt-2.6/drivers/s390/cio/css.c
@@ -451,6 +451,7 @@ static int reprobe_subchannel(struct sub
 		break;
 	case -ENXIO:
 	case -ENOMEM:
+	case -EIO:
 		/* These should abort looping */
 		break;
 	default:

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

