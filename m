Return-Path: <linux-kernel-owner+w=401wt.eu-S933314AbXCUDFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbXCUDFz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 23:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933291AbXCUDFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 23:05:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:44792 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932833AbXCUDFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 23:05:53 -0400
Date: Tue, 20 Mar 2007 20:05:38 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: BLK_DEV_MD with CONFIG_NET
Message-Id: <20070320200538.5270d636.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


drivers/md/md.c calls csum_partial().

IF CONFIG_NET=n and BLK_DEV_MD=y, if arch/*/lib/Makefile
puts csum-partial.o or checksum.o into lib-y, the function
is present.  (Of course, if the function is placed in
obj-y, there is no problem.)

If CONFIG_NET=n and BLK_DEV_MD=n, if arch/*/lib/Makefile
puts csum-partial.o or checksum.o into lib-y, the function
is removed from the kernel image due to having no built-in
callers.

Build a kernel with CONFIG_NET-n and CONFIG_BLK_DEV_MD=m.
Unless csum_partial() is built and kept by some arch Makefile,
the result is:
ERROR: "csum_partial" [drivers/md/md-mod.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2


Any suggested solutions?


Recorded for posterity here:
  http://bugzilla.kernel.org/show_bug.cgi?id=8242

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
