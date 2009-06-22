Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZFVWKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZFVWKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 18:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbZFVWKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 18:10:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57611 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750740AbZFVWKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 18:10:36 -0400
Subject: Regression: ppc powerstation boot hang caused by slab
 initialisation code
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 17:10:35 -0500
Message-Id: <1245708635.17035.6.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a boot hang on my powerstation with recent kernels.  It
hangs in the early prom init code:

Please wait, loading kernel...
   Elf64 kernel loaded...
Loading ramdisk...
ramdisk loaded at 02500000, size: 8280 Kbytes
OF stdout device is: /ht/isa@8/serial@2f8
Preparing to boot Linux version 2.6.30 (jejb@claymoor) (gcc version
4.3.3 (Debian 4.3.3-10) ) #1 SMP Mon Jun 22 09:59:35 CDT 2009
command line: root=/dev/sda3 ro console=ttyS0,19200n1 
memory layout at init:
  alloc_bottom : 0000000002d16000
  alloc_top    : 0000000030000000
  alloc_top_hi : 0000000080000000
  rmo_top      : 0000000030000000
  ram_top      : 0000000080000000
instantiating rtas at 0x000000002fff5000... done
boot cpu hw idx 0000000000000000
starting cpu hw idx 0000000000000001... done
starting cpu hw idx 0000000000000002... done
starting cpu hw idx 0000000000000003... done
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x0000000003117000 -> 0x0000000003117640
Device tree struct  0x0000000003118000 -> 0x000000000311b000
Calling quiesce...
returning from prom_init

Git bisect identifies this commit:

commit 83b519e8b9572c319c8e0c615ee5dd7272856090
Author: Pekka Enberg <penberg@cs.helsinki.fi>
Date:   Wed Jun 10 19:40:04 2009 +0300

    slab: setup allocators earlier in the boot sequence

So it's something do do with early slab initialisation.  I'll try to
track it down, but reverting it is hard because it seems to have a chain
of dependent commits.

James


