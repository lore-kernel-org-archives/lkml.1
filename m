Return-Path: <linux-kernel-owner+w=401wt.eu-S966145AbZLHU5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966145AbZLHU5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 15:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966135AbZLHU52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 15:57:28 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:43978 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966119AbZLHU52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 15:57:28 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: alacrityvm-next: clearly specify ioq endianness
Date: Tue,  8 Dec 2009 12:57:29 -0800
Message-Id: <1260305854-31472-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.6.0.rc1.71.gfba5.dirty
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Tue, 08 Dec 2009 12:57:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a respin of the previous patch series against alacrityvm.git's
linux-next branch, to facilitate easier merging with the linux-next tree.

The SHM_SIGNAL and IOQ code is meant to be used for communication channels
between systems with different bit widths and operating systems.
Conceivably, this could include systems with different endianness as well,
for example, using QEMU on x86 to emulate a powerpc.

This patch series annotates all shared structures as little endian, and
fixes up all users. This means that there is no overhead in the most common
case, x86-on-x86. The byteswaps compile out.

[RESEND: added LKML to CC per Greg Haskins' request]

 drivers/net/vbus-enet.c    |   36 ++++++++++++++++++------------------
 drivers/vbus/bus-proxy.c   |    2 +-
 drivers/vbus/pci-bridge.c  |   18 +++++++++---------
 include/linux/ioq.h        |   24 ++++++++++++------------
 include/linux/shm_signal.h |    8 ++++----
 lib/ioq.c                  |   28 ++++++++++++++++------------
 6 files changed, 60 insertions(+), 56 deletions(-)

Thanks,
Ira
