Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYE3XjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYE3XjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:39:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbYE3Xi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:38:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:64382 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412AbYE3Xi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:38:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=A3ySj+urxdASkYcavxZIhMkXOFW77mvntUo0L7vNtmIeDRcnmpKvm/apS3asLCGF+ozjdeCRfYxWBVQdDfZaplvy3uJ5x5sNbpocnIBejxTx3PPyff+RuiosEyWI+wc7UhlPr4CKWge/rrX1A7K2gbdjvpjk9XWj8TP5WT7X/zE=
Date: Sat, 31 May 2008 03:34:45 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] isdn divas: fix proc creation
Message-ID: <20080530233445.GB7358@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. creating proc entry and not saving pointer to PDE and checking it
   is not going to work.
2. if proc entry wasn't created, no reason to remove it on error path.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/isdn/hardware/eicon/divasmain.c |    1 -
 drivers/isdn/hardware/eicon/divasproc.c |    4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -806,7 +806,6 @@ static int DIVA_INIT_FUNCTION divas_init(void)
 
 	if (!create_divas_proc()) {
 #ifdef MODULE
-		remove_divas_proc();
 		divas_unregister_chrdev();
 		divasfunc_exit();
 #endif
--- a/drivers/isdn/hardware/eicon/divasproc.c
+++ b/drivers/isdn/hardware/eicon/divasproc.c
@@ -125,8 +125,8 @@ static const struct file_operations divas_fops = {
 
 int create_divas_proc(void)
 {
-	proc_create(divas_proc_name, S_IFREG | S_IRUGO, proc_net_eicon,
-		    &divas_fops);
+	divas_proc_entry = proc_create(divas_proc_name, S_IFREG | S_IRUGO,
+					proc_net_eicon, &divas_fops);
 	if (!divas_proc_entry)
 		return (0);
 

