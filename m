Return-Path: <linux-kernel-owner+w=401wt.eu-S1030974AbXEAS1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030974AbXEAS1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031045AbXEAS0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:26:46 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:38477 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030968AbXEAS0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:26:15 -0400
Date: Tue, 1 May 2007 14:21:59 -0400
From: Jeff Dike <jdike@addtoit.com>
To: akpm@osdl.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Antoine Martin <antoine@nagafix.co.uk>
Subject: [PATCH /6] UML - pcap devices should get MACs from command line
Message-ID: <20070501182159.GA8368@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a pcap device to be assigned a MAC on the command line.  They
don't really need one, but it is handy to be able to do when your
distro assigns a new ethernet device whenever it sees a new MAC.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/drivers/pcap_kern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.21-mm/arch/um/drivers/pcap_kern.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/drivers/pcap_kern.c	2007-04-27 16:15:41.000000000 -0400
+++ linux-2.6.21-mm/arch/um/drivers/pcap_kern.c	2007-04-27 16:15:57.000000000 -0400
@@ -70,7 +70,7 @@ int pcap_setup(char *str, char **mac_out
 		  .filter 	= NULL });
 
 	remain = split_if_spec(str, &host_if, &init->filter,
-			       &options[0], &options[1], NULL);
+			       &options[0], &options[1], mac_out, NULL);
 	if(remain != NULL){
 		printk(KERN_ERR "pcap_setup - Extra garbage on "
 		       "specification : '%s'\n", remain);
