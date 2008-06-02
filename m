Return-Path: <linux-kernel-owner+w=401wt.eu-S1760238AbYFBMep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238AbYFBMep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754720AbYFBMef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:34:35 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:48739 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754203AbYFBMee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:34:34 -0400
Date: Mon, 02 Jun 2008 21:34:33 +0900 (JST)
Message-Id: <20080602.213433.193692201.ryov@valinux.co.jp>
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com
Cc: agk@sourceware.org
Subject: [PATCH 0/2] dm-ioband: I/O bandwidth controller v1.1.0:
 Introduction
From: Ryo Tsuruta <ryov@valinux.co.jp>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is dm-ioband version 1.1.0 release.

Dm-ioband is an I/O bandwidth controller implemented as a device-mapper
driver, which gives specified bandwidth to each job running on the same
physical device.

- Can be applied to the kernel 2.6.26-rc2-mm1.
- Changes from 1.0.0 (posted on May 19, 2008):
  - Measures against high memory pressure.
    I/O requests to reclaim pages won't be blocked in dm-ioband
    even when the group doesn't have the right to issue any more I/Os.
    But it can keep to control the bandwidth of the group since these
    I/Os will be counted as debt of the group.
  - Performance tuning
    Improve the performance when a lot of ioband groups are created.
    It is useful when you want to control bandwidth on a per user
    basis. For example, you can create an ioband group and give an
    weight to a user once the user is logged in. The combination of
    dm-ioband, the cgroup memory resource controller and the
    CPU resource controller will work more effectively.

I also announce that we have launched "Linux Block I/O Bandwidth
Control Project" website http://people.valinux.co.jp/~ryov/bwctl/ .
The goal of this project is to develop a block I/O bandwidth
controller on Linux. You can find information about the followings:

- dm-ioband
  This device mapper driver.
- iobandctl
  An administration tool for dm-ioband, which makes it easy to
  configure the dm-ioband device.
- Block I/O Tracking
  Block I/O tracking, which we call "bio cgroup", provides block I/O
  tracking mechanism. It makes dm-ioband be able to control the block
  I/O bandwidths even when it accepts delays write requests.

Thanks,
Ryo Tsuruta
