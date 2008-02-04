Return-Path: <linux-kernel-owner+w=401wt.eu-S1756453AbYBDPAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453AbYBDPAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751626AbYBDPAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:00:31 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:42553 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943AbYBDPAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:00:30 -0500
Date: Mon, 4 Feb 2008 18:00:23 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: linux-kernel@vger.kernel.org
Subject: Kernel can't find / in 2.6.24-git?
Message-ID: <20080204150023.GA25790@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't panic. First thing to try is reenabling CONFIG_SYSFS_DEPRECATED.


edfaa7c36574f1bf09c65ad602412db9da5f96bf is first bad commit
commit edfaa7c36574f1bf09c65ad602412db9da5f96bf
Author: Kay Sievers <kay.sievers@vrfy.org>
Date:   Mon May 21 22:08:01 2007 +0200

    Driver core: convert block from raw kobjects to core devices
    
    This moves the block devices to /sys/class/block. It will create a
    flat list of all block devices, with the disks and partitions in one
    directory. For compatibility /sys/block is created and contains symlinks
    to the disks.
    
      /sys/class/block
      |-- sda -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda
      |-- sda1 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda1
      |-- sda10 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda10
      |-- sda5 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda5
      |-- sda6 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda6
      |-- sda7 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda7
      |-- sda8 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda8
      |-- sda9 -> ../../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda9
      `-- sr0 -> ../../devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0
    
      /sys/block/
      |-- sda -> ../devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda
      `-- sr0 -> ../devices/pci0000:00/0000:00:1f.2/host1/target1:0:0/1:0:0:0/block/sr0
    
    Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

:040000 040000 53a7ec4a5f3ee05f0135957fc7a78bdf916c4c44 f60ed2905abd5deef19294130a3b93a94bfef17e M	block
:040000 040000 cc8ec8ea50163ca4a76b91af4df5047e3747eaaa a3f18d189f18e1213ba3e44df710873c195ab47a M	drivers
:040000 040000 5695733bc4880adf7c7ded94d33ac9a32e7611ce dd53c846318820df976344e7ebaaba252fe537ed M	fs
:040000 040000 d75784c54072a715eff896b73523e66773d98d66 7055e0b911a52bd8ee4afc7f23df00a00870af68 M	include
:040000 040000 e94ba7819ccceacdda2c2f0f72017c543b4b6808 eb7d1e39d32a4ef6b48431f6a519774b9cd4bf57 M	init

