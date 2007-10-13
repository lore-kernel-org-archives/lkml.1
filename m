Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbXJMHKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbXJMHKp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbXJMHKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:10:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59500 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752785AbXJMHKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:10:35 -0400
Date: Sat, 13 Oct 2007 00:10:27 -0700
From: Paul Jackson <pj@sgi.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <willy@debian.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       Vladimir Saveliev <vs@namesys.com>,
       Edward Shishkin <edward@namesys.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Message-Id: <20071013001027.535cc294.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The git-block patches in 2.6.23-mm1 freeze my ia64 SN Altix hard on boot.
Not good (tm).

Something broke between the git-block patch of Sept 26 in 2.6.23-rc8-mm2
and the git-block patches of Oct 10-11 in 2.6.23-mm1 on my ia64 SN Altix
system using sn2_defconfig.

Bisecting 2.6.23-mm1 narrows the problem down to the git-block patches:

    git-block.patch
    git-block-fixup-1.patch
    git-block-fixup.patch
    git-block-fixup-fix.patch
    git-block-borkages.patch
    git-block-s390-fix.patch

I can boot 2.6.23-rc8-mm2 fine, but I freeze early in boot
on 2.6.23-mm1, after the following prints on the console:

    McKinley Errata 9 workaround not needed; disabling it
    SLUB: Genslabs=26, HWalign=128, Order=0-2, MinObjects=8, CPUs=8, Nodes=1024
    Dentry cache hash table entries: 1048576 (order: 9, 8388608 bytes)
    Inode-cache hash table entries: 524288 (order: 8, 4194304 bytes)
    Mount-cache hash table entries: 1024
    ACPI: Core revision 20070126
    Boot processor id 0x0/0x0
    Brought up 8 CPUs
    Total of 8 processors activated (15564.80 BogoMIPS).

The next output that I -would- have expected, based on successful boots
without these patches, but never get, is:

    net_namespace: 120 bytes
    DMI not present or invalid.
    xor: measuring software checksum speed
       ia64      :  2692.000 MB/sec
    xor: using function: ia64 (2692.000 MB/sec)
    NET: Registered protocol family 16
    ACPI  DSDT OEM Rev 0x20101

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
