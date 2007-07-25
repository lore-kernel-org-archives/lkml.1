Return-Path: <linux-kernel-owner+w=401wt.eu-S1765222AbXGYMyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765222AbXGYMyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 08:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759695AbXGYMyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 08:54:06 -0400
Received: from knopper.net ([85.214.68.145]:40300 "EHLO knopper.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758637AbXGYMyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 08:54:05 -0400
X-Greylist: delayed 1434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 08:54:05 EDT
Date: Wed, 25 Jul 2007 14:36:53 +0200
From: Klaus Knopper <cloop@knopper.net>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: kernel 2.6.22 do_generic_mapping_read() hangs for no apparent reason
Message-ID: <20070725123653.GP5357@knopper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Knopper Networks
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry about the quite poor subject. I just got stuck in the debugging
and cannot point to the exact location of the problem, though I am quite
sure it's a kernel 2.6.22 problem, and not a "third-party-module" problem.

cloop-2.06 (block device module similar to loop.c) uses
do_generic_file_read(), which is translated to do_generic_mapping_read()
in mm/filemap.c, which worked fine up to and including Kernel 2.6.21.6.
In Kernel 2.6.22, do_generic_file_read() blocks indefinitely with no log
message at all, whenever data is read from the file and the read_actor
is NOT called (i.e. parts of the file-to-be-read are probably already
cached somewhere).

Unfortunately, apart from cloop, there seem to be not many drivers that
still use do_generic_file_read, so maybe it's time for a rewrite
anyways.

If anybody would volunteer to help debugging or rewriting cloop to work
with Kernels >= 2.6.22, a lot of people developing live CDs would be
very happy (including me. ;-)

cloop source code is at
http://debian-knoppix.alioth.debian.org/sources/cloop_2.06-2.tar.gz
(make cloop.ko KERNEL_DIR=/path/to/kernel/source)

With kind regards
-Klaus Knopper
