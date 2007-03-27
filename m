Return-Path: <linux-kernel-owner+w=401wt.eu-S934156AbXC0Sa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934156AbXC0Sa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:30:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934162AbXC0Sa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:30:57 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45430 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934156AbXC0Say (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:30:54 -0400
Date: Tue, 27 Mar 2007 14:27:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 3/6] UML - Fix device unplug crash
Message-ID: <20070327182748.GA8405@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a NULL dereference when unplugging a device.  The default value of
err_msg wants to be "" in case the driver doesn't modify it.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/mconsole_kern.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.21-mm/arch/um/drivers/mconsole_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/mconsole_kern.c	2007-03-27 11:35:47.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/mconsole_kern.c	2007-03-27 11:46:28.000000000 -0400
@@ -614,6 +614,9 @@ void mconsole_remove(struct mc_request *
 	err_msg = NULL;
 	err = (*dev->remove)(n, &err_msg);
 	switch(err){
+	case 0:
+		err_msg = "";
+		break;
 	case -ENODEV:
 		if(err_msg == NULL)
 			err_msg = "Device doesn't exist";
