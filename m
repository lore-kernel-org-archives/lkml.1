Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbZKCE3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbZKCE3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbZKCE3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:29:11 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:55806 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbZKCE3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:29:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=CzwFKBImSyx5ilYchFKeNjeejdLH1Hw4yig0Ui8l+ndtrJ7dK9tuH/rZslDt/R+FlO
         4y6i5RREArWlwPKK4lGzbm/pMFrYyYWqzwIiBsx+3hpehCMI2RE9wLJ8A3XiiGBJHjNC
         8eiUg540reLpQLjNCYlxXHt4tijhr+r6DJiag=
MIME-Version: 1.0
Date: Tue, 3 Nov 2009 10:29:12 +0600
Message-ID: <b9df5fa10911022029q197a0c5dkbbda609f4e41287@mail.gmail.com>
Subject: [PATCH -mm] char, moxa: Make isabrds variable global.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jirislaby@gmail.com, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 When CONFIG_MODULE=n and CONFIG_PCI=n, then variable
isabrds becomes unused variable. So place it outside
moxa_init solves this problem.

 We were warned by the following warning:

drivers/char/moxa.c: In function `moxa_init':
drivers/char/moxa.c:1012: warning: unused variable `isabrds'

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
----

--- linus/drivers/char/moxa.c	2009-09-11 20:39:02.000000000 +0600
+++ rakib/drivers/char/moxa.c	2009-11-03 10:57:44.000000000 +0600
@@ -1007,9 +1007,10 @@ static struct pci_driver moxa_pci_driver
 };
 #endif /* CONFIG_PCI */

+static unsigned int __initdata isabrds;
+
 static int __init moxa_init(void)
 {
-	unsigned int isabrds = 0;
 	int retval = 0;

 	printk(KERN_INFO "MOXA Intellio family driver version %s\n",
