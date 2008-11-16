Return-Path: <linux-kernel-owner+w=401wt.eu-S1753283AbYKPOsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbYKPOsK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 09:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYKPOrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 09:47:52 -0500
Received: from mail.suse.de ([195.135.220.2]:44822 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706AbYKPOrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 09:47:51 -0500
From: Bernhard Walle <bwalle@suse.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com, Bernhard Walle <bwalle@suse.de>
Subject: Turn CONFIG_STRICT_DEVMEM in sysctl dev.mem.restricted
Date: Sun, 16 Nov 2008 15:47:45 +0100
Message-Id: <1226846868-9595-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series turns CONFIG_STRICT_DEVMEM in a sysctl
dev.mem.restricted.

While the restricted /dev/mem is useful in most scenarios, it is not
when doing live debugging. The crash utility
(http://people.redhat.com/~anderson) needs access to /dev/mem.

As distributor (at least for "enterprise" distributions) you need both:
The protection in the general case and the ability to do live debugging.
The patch doesn't make the kernel more insecure: Without SELinux or
AppArmor, it has always been possible to circumvent that /dev/mem
restriction. With it, you can also prevent the (super) user from doing
"sysctl dev.mem.restricted=1".

This patch series differs in two ways from the original submission:

  - The patch that removes CONFIG_STRICT_DEVMEM has been added.
  - The binary sysctl is removed, now it's only a /proc/sys sysctl.

While the original submission of CONFIG_STRICT_DEVMEM mentions that the
option has been in RHEL and Fedora for 4 years without problems, that's
only a half of the story. The truth is that at least RHEL has /dev/crash
exactly to circumvent that /dev/mem restriction. Don't tell me that this
is better than having that sysctl entry. ;-)

The patch has been tested on i386. There should be no difference to
x86_64.


Signed-off-by: Bernhard Walle <bwalle@suse.de>


