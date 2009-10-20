Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbZJTFzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbZJTFzj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 01:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZJTFzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 01:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbZJTFzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 01:55:38 -0400
From: Amit Shah <amit.shah@redhat.com>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v9 0/1] virtio-console: Support for generic ports and multiple consoles
Date: Tue, 20 Oct 2009 11:24:54 +0530
Message-Id: <1256018095-19400-1-git-send-email-amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

Here is a new iteration of the patch series that implements a
transport for guest and host communications.

I've tested for compatibility (old qemu & new kernel, new qemu & old
kernel, new qemu & new kernel) and it all works fine. To maintain
backward compatibility, the first port to be spawned (port at id 0) is
to be a console port, to be bound to hvc. This keeps new host, old
guest happy.

A testsuite is put up at the following site that has an interactive
test program that can be run in the guest. It also has an automated
test suite that tests the major functionalities presented here:

    http://fedorapeople.org/gitweb?p=amitshah/public_git/test-virtserial.git

This version passes all the automated tests there.

Christian has tested the console functionality on s390.

v9:
- Add debugfs files for each port to expose some port-specific information for
  easier debugging
- Port hotplug fix
- Disallow opening of console ports (open(/dev/vcon0) should fail)
- A couple of other minor fixes.

Please review and apply,
	Amit

Amit Shah (1):
  virtio_console: Add support for multiple ports for generic guest and
    host communication

 drivers/char/Kconfig           |    6 +
 drivers/char/virtio_console.c  | 1372 ++++++++++++++++++++++++++++++++++++----
 include/linux/virtio_console.h |   50 ++-
 3 files changed, 1292 insertions(+), 136 deletions(-)

