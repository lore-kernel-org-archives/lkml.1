Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbXCYQL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbXCYQL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751769AbXCYQL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:11:28 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:45737 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbXCYQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:11:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:reply-to:to:cc:subject:message-id:mime-version:content-type:from;
        b=o7PWwHdOZ53O3QoxNz+RZLxzq55kbH47QgtOP8TEKUaNRT4VYC8FYLP6CBftJijbwLRjEhris9xb+bKkVYFawdFj1r9ioZ7tHh3C04o2HwDvWeYfyx/kP8k5OADIYbGb0R7beIxZpjq1gB8mxMWRN7l7+cI0CdLWxov790pzXBM=
Date: Sun, 25 Mar 2007 12:11:23 -0400 (EDT)
Reply-To: parag.warudkar@gmail.com
To: linux-kernel@vger.kernel.org
cc: akpm@linux-foundation.org, torvalds@linux-foundation.org
Subject: [PATCH]fdomain.c: get rid of unused stuff
Message-ID: <Pine.LNX.4.64.0703251206330.17623@paragw-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fdomain.c uses the below stuff only if PCMCIA is not defined.
This causes unused variables to be defined when PCMCIA is not defined. 
Wrap variables and functions around #ifndef PCMCIA appropriately to avoid 
this.

4 less compiler warnings.

Compile tested on i386.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

--- linux-2.6/drivers/scsi/fdomain.c	2007-03-24 21:44:17.000000000 -0400
+++ linux-2.6-wk/drivers/scsi/fdomain.c	2007-03-25 11:45:26.000000000 -0400
@@ -410,6 +410,7 @@
  static char * fdomain = NULL;
  module_param(fdomain, charp, 0);

+#ifndef PCMCIA
  static unsigned long addresses[] = {
     0xc8000,
     0xca000,
@@ -502,6 +503,7 @@
  };

  #define SIGNATURE_COUNT ARRAY_SIZE(signatures)
+#endif /* ifndef PCMCIA */

  static void print_banner( struct Scsi_Host *shpnt )
  {
@@ -646,7 +648,7 @@
     Sometimes it is possible to use the computer's BIOS setup screen to
     configure a PCI system so that one of these IRQs will be used by the
     Future Domain card. */
-
+#ifndef PCMCIA
  static int fdomain_get_irq( int base )
  {
     int options = inb(base + Configuration1);
@@ -664,6 +666,7 @@
     	return 0;
     return ints[(options & 0x0e) >> 1];
  }
+#endif

  static int fdomain_isa_detect( int *irq, int *iobase )
  {
