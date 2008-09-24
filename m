Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbYIXKLQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbYIXKLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:11:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbYIXKLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:11:02 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:37156 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751573AbYIXKLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:11:00 -0400
Date: Wed, 24 Sep 2008 19:10:59 +0900 (JST)
Message-Id: <20080924.191059.193698894.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
Subject: [PATCH 0/8] I/O bandwidth controller and BIO tracking
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

These patchsets are the new releases of dm-ioband and bio-cgroup which
are ported to 2.6.27-rc5-mm1.

dm-ioband
  Dm-ioband is an I/O bandwidth controller implemented as a
  device-mapper driver, which gives specified bandwidth to each job
  running on the same block device. A job is a group of processes
  with the same pid or pgrp or uid or a virtual machine such as KVM
  or Xen. A job can also be a cgroup by applying the bio-cgroup patch.

bio-cgroup
  Bio-cgroup is a BIO tracking mechanism, which is implemented on the
  cgroup memory subsystem. With the mechanism, it is able to determine
  which cgroup each of bio belongs to, even when the bio is one of
  delayed-write requests issued from a kernel thread such as pdflush.

The following is a list of patches:

  [PATCH 1/8] dm-ioband: Patch of device-mapper driver
  [PATCH 2/8] dm-ioband: Documentation of design overview, installation,
                         command reference and examples.
  [PATCH 3/8] bio-cgroup: Introduction
  [PATCH 4/8] bio-cgroup: Split the cgroup memory subsystem into two parts
  [PATCH 5/8] bio-cgroup: Remove a lot of "#ifdef"s
  [PATCH 6/8] bio-cgroup: Implement the bio-cgroup
  [PATCH 7/8] bio-cgroup: Add a cgroup support to dm-ioband
  [PATCH 8/8] bio-cgroup: Dirty page tracking

Please see the following site for more information:
  Linux Block I/O Bandwidth Control Project
  http://people.valinux.co.jp/~ryov/bwctl/

Thanks,
Ryo Tsuruta
