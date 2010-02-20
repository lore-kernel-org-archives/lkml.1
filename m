Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811Ab0BTLNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:13:51 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:54574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab0BTLNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:13:50 -0500
Subject: Re: sysfs lockdep complaint
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
In-Reply-To: <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
References: <1266485543.6539.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200126x22b262b3r8b9b58e3cee34077@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 12:13:49 +0100
Message-ID: <1266664429.11514.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-02-20 at 17:26 +0800, Américo Wang wrote:

> This should be fixed by the patchset from Eric:
> 
> http://lkml.org/lkml/2010/2/11/334

That patchset doesn't even compile.

johannes

---
 drivers/pci/pci-sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/drivers/pci/pci-sysfs.c	2010-02-20 12:12:28.207979616 +0100
+++ wireless-testing/drivers/pci/pci-sysfs.c	2010-02-20 12:12:54.588603464 +0100
@@ -642,7 +642,7 @@ void pci_create_legacy_files(struct pci_
 	if (!b->legacy_io)
 		goto kzalloc_err;
 
-	sysfs_bin_attr_init(&b->legacy_io);
+	sysfs_bin_attr_init(b->legacy_io);
 	b->legacy_io->attr.name = "legacy_io";
 	b->legacy_io->size = 0xffff;
 	b->legacy_io->attr.mode = S_IRUSR | S_IWUSR;
@@ -655,8 +655,8 @@ void pci_create_legacy_files(struct pci_
 		goto legacy_io_err;
 
 	/* Allocated above after the legacy_io struct */
-	sysfs_bin_attr_init(&b->legacy_mem);
 	b->legacy_mem = b->legacy_io + 1;
+	sysfs_bin_attr_init(b->legacy_mem);
 	b->legacy_mem->attr.name = "legacy_mem";
 	b->legacy_mem->size = 1024*1024;
 	b->legacy_mem->attr.mode = S_IRUSR | S_IWUSR;


