Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbXCUXpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbXCUXpP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbXCUXpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:45:15 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:48127 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932306AbXCUXpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:45:12 -0400
Message-ID: <04bf01c76c13$5f25ce00$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] - fix compile warning: `found' might be used uninitialized in this function
Date: Thu, 22 Mar 2007 00:48:05 +0100
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello !

the attached patch should fix the following compile warning:

fs/block_dev.c: In function `bd_claim_by_kobject':
fs/block_dev.c:953: warning: `found' might be used uninitialized in this 
function

i`m an absolutely awful programmer , but feel free to comment, ignore or 
.... merge.

regards
Roland Kletzing


--- linux-2.6.20.3/fs/block_dev.c.orig  2007-03-22 00:07:49.270353920 +0100
+++ linux-2.6.20.3/fs/block_dev.c       2007-03-22 00:07:33.875694264 +0100
@@ -950,7 +950,7 @@
                                struct kobject *kobj)
 {
        int res;
-       struct bd_holder *bo, *found;
+       struct bd_holder *bo, *found = NULL;

        if (!kobj)
                return -EINVAL; 

