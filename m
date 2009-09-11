Return-Path: <linux-kernel-owner+w=401wt.eu-S1754017AbZIKHir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbZIKHir (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 03:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZIKHiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 03:38:46 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61951 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbZIKHiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 03:38:46 -0400
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [2.6.31] Memory leak in load_module()?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <200909111638.IDC17135.FOHJOtFFMQSVLO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 11 Sep 2009 16:38:46 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I changed CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE to 2000 and did

# insmod /lib/modules/2.6.31/kernel/drivers/edac/r82600_edac.ko
insmod: error inserting '/lib/modules/2.6.31/kernel/drivers/edac/r82600_edac.ko': -1 Unknown symbol in module
# echo scan > /sys/kernel/debug/kmemleak
# dmesg
r82600_edac: Unknown symbol edac_mc_del_mc
r82600_edac: Unknown symbol edac_mc_add_mc
r82600_edac: Unknown symbol edac_pci_create_generic_ctl
r82600_edac: Unknown symbol edac_mc_alloc
r82600_edac: Unknown symbol edac_mc_find_csrow_by_page
r82600_edac: Unknown symbol edac_mc_free
r82600_edac: Unknown symbol edac_mc_handle_ce
r82600_edac: Unknown symbol edac_mc_handle_ue
r82600_edac: Unknown symbol edac_pci_release_generic_ctl
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
# tail -n 4 /sys/kernel/debug/kmemleak
unreferenced object 0xd643a788 (size 32):
  comm "insmod", pid 2854, jiffies 4294791099
  backtrace:
    [<ffffffff>] 0xffffffff

Is this real memory leak?

I used CentOS 5.3 on i686.
Config is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.31

Regards.
