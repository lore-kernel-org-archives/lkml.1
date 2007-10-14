Return-Path: <linux-kernel-owner+w=401wt.eu-S1761290AbXJNF5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761290AbXJNF5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 01:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbXJNF5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 01:57:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51031 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753872AbXJNF5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 01:57:39 -0400
Date: Sat, 13 Oct 2007 22:57:35 -0700
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: git-sched patch won't boot on SN arch, 2.6.23-mm1
Message-Id: <20071013225735.58c6415c.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The git-sched patch in 2.6.23-mm1 freezes my ia64 SN Altix hard on boot.
Not good (tm).

Something broke between the git-sched patch of Sept 26 in 2.6.23-rc8-mm2
and the git-sched patch of Oct 10 in 2.6.23-mm1 on my ia64 SN Altix
system using sn2_defconfig.

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
without this patch, but never get, is:
    net_namespace: 120 bytes
    DMI not present or invalid.
    xor: measuring software checksum speed
       ia64      :  2692.000 MB/sec
    xor: using function: ia64 (2692.000 MB/sec)
    NET: Registered protocol family 16
    ACPI  DSDT OEM Rev 0x20101

My .config has the following elements matching "SCHED"
    # CONFIG_FAIR_GROUP_SCHED is not set
    CONFIG_IOSCHED_NOOP=y
    CONFIG_IOSCHED_AS=y
    CONFIG_IOSCHED_DEADLINE=y
    CONFIG_IOSCHED_CFQ=y
    CONFIG_DEFAULT_IOSCHED="anticipatory"
    CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
    CONFIG_SCHED_SMT=y
    # CONFIG_NET_SCHED is not set
    # CONFIG_USB_EHCI_TT_NEWSCHED is not set
    CONFIG_SCHED_DEBUG=y
    # CONFIG_SCHEDSTATS is not set

I'm pretty certain that I also saw this hang with the config setting:
    CONFIG_FAIR_GROUP_SCHED=y
though there is a small chance I'm confused on that point.

You'll probably need more information, but I can't guess what,
so ask away.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
