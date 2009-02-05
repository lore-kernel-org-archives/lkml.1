Return-Path: <linux-kernel-owner+w=401wt.eu-S1758801AbZBEJFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801AbZBEJFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 04:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757428AbZBEJEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 04:04:44 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:53381 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZBEJEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 04:04:41 -0500
Message-Id: <20090205081810.331987920@nttdata.co.jp>
User-Agent: quilt/0.45-1
Date: Thu, 05 Feb 2009 17:18:10 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp
Subject: [TOMOYO #15 0/8] TOMOYO Linux
X-OriginalArrivalTime: 05 Feb 2009 08:22:24.0199 (UTC) FILETIME=[DF743D70:01C9876A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.

Changes since previous posting.

1. Removed d_realpath(). For now, TOMOYO uses __d_path().
2. Removed singly linked list. For now, TOMOYO uses standard doubly linked list
   with "struct rw_semaphore".
3. Fixed bitmap initialization error in tomoyo_update_single_path_acl().
4. Updated patch description.

How to try:

1. Apply patches and compile kernel with CONFIG_SECURITY_TOMOYO=y.
2. Download userspace tools (ccs-tools) available at
   http://sourceforge.jp/projects/tomoyo/releases/30298/ and
   extract and run 'make -C ccstools/ install' as root user.
3. Run /usr/lib/ccs/tomoyo_init_policy.sh as root user.
4. Run following commands to set learning-mode as default.
   (This step is optional but recommended on your first try.)
   # echo '<kernel>' > /etc/tomoyo/domain_policy.conf
   # echo 'use_profile 1' >> /etc/tomoyo/domain_policy.conf
5. Reboot.
   (If you compiled kernel with CONFIG_SECURITY_{SELINUX,SMACK}=y,
    add 'security=tomoyo' to kernel's command line.)
6. Run /usr/sbin/ccs-editpolicy to browse and edit policy.

LiveCD-based tutorials are available at
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/ubuntu8.04-live/
http://tomoyo.sourceforge.jp/en/1.6.x/1st-step/centos5-live/ .
Though these tutorials use non-LSM version of TOMOYO,
they are useful for you to know what TOMOYO is.

These patches are refreshed for
security-testing-2.6.git-27421e211a39784694b597dbf35848b88363c248.tar.gz ,
but should be applicable for 2.6.29-rc3 and later.

Regards.

--

