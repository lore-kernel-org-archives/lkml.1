Return-Path: <linux-kernel-owner+w=401wt.eu-S932393AbZAGXNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbZAGXNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbZAGXNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:13:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:46727 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbZAGXNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:13:21 -0500
Date: Wed, 7 Jan 2009 15:11:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: [PATCH 0/7] V3 of the async function call patches
Message-ID: <20090107151151.458333c1@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

version 3 of the async function call patches

* Dropped the ACPI part; it broke i surprising ways; needs a rethink
  (working with Len and co on that)
* Included asynchronous delete()


There is still no integration with the out of tree slow-work patch;
the slow-work patch does really weird things with refcounts that make it
really specific to cachefs and, frankly, I think it's a rather
weird design.

The overlap is maybe 200 lines of code at most, of which 100+ would
need to be added just to deal with the various weirdnesses. I really
don't think this is a good idea or a fair requirement on the async
function call patch series.

The following changes since commit 8903709b054a8dafe4e8c6d9a6444034d7aba36f:
  Harvey Harrison (1):
        xtensa: introduce swab.h

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-async.git master

Arjan van de Ven (7):
      async: Asynchronous function calls to speed up kernel boot
      fastboot: make scsi probes asynchronous
      fastboot: make the libata port scan asynchronous
      fastboot: Make libata initialization even more async
      async: make the final inode deletion an asynchronous event
      bootchart: improve output based on Dave Jones' feedback
      async: don't do the initcall stuff post boot

 drivers/ata/libata-core.c |   96 +++++++-------
 drivers/scsi/scsi_scan.c  |    3 +
 drivers/scsi/sd.c         |  109 ++++++++++------
 fs/inode.c                |   20 ++-
 fs/super.c                |   10 ++
 include/linux/async.h     |   25 ++++
 include/linux/fs.h        |    5 +
 init/do_mounts.c          |    2 +
 init/main.c               |    5 +-
 kernel/Makefile           |    3 +-
 kernel/async.c            |  321 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/autoprobe.c    |    5 +
 kernel/module.c           |    2 +
 scripts/bootgraph.pl      |   16 ++-
 14 files changed, 521 insertions(+), 101 deletions(-)
 create mode 100644 include/linux/async.h
 create mode 100644 kernel/async.c


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
