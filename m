Return-Path: <linux-kernel-owner+w=401wt.eu-S937247AbXGTVnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937247AbXGTVnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXGTVmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:42:53 -0400
Received: from deine-taler.de ([217.160.107.63]:51734 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932227AbXGTVmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:42:51 -0400
X-Greylist: delayed 1789 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 17:42:51 EDT
Date: Fri, 20 Jul 2007 23:13:00 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: linux-kernel@vger.kernel.org
Subject: Is PIE randomization breaking klibc binaries?
Message-ID: <20070720211300.GA21644@deine-taler.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since this week new linux-2.6/master kernels don't work with my
initial ram disks. The sleep binary runs repeatingly into
segmentation faults until the Busybox shell starts. My system is a
x86-64 with Kubuntu Feisty Fawn.

By bisecting I found out that the PIE randomization patch (commit 60bfba7e)
appears to cause the segmentation faults.

Digging further into the issue I found out, that the sleep binary
on the initial ramdisk is a klibc binary. /usr/bin/file says it is
statically linked and uses shared libraries. I have no clue about
klibc, but the binaries seem to be statically linked, but load a
shared library; probably at a fixed address. Other klibc binaries are also
running into segmentation faults. Busybox is working, but it is
statically linked and doesn't use a shared library.

It looks like that the PIE randomization patch breaks klibc
binaries on x86-64.

-- 
Uli Kunitz
