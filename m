Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbZKCQjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbZKCQjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 11:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbZKCQjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 11:39:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbZKCQjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 11:39:53 -0500
From: Amit Shah <amit.shah@redhat.com>
To: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Cc: virtualization@linux-foundation.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH v10 0/1]  virtio-console: Support for generic ports and multiple consoles
Date: Tue,  3 Nov 2009 22:08:38 +0530
Message-Id: <1257266319-24300-1-git-send-email-amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Rusty, would it improve the chances of getting this patch in your
tree if this description were written with latex instead of without
it?)

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

v10:
- only one process can open a port in the guest
- minor fixes for throttling and caching cases


Please review and apply,
	Amit

Amit Shah (1):
  virtio_console: Add support for multiple ports for generic guest and
    host communication

 drivers/char/Kconfig           |    6 +
 drivers/char/virtio_console.c  | 1412 ++++++++++++++++++++++++++++++++++++----
 include/linux/virtio_console.h |   50 ++-
 3 files changed, 1332 insertions(+), 136 deletions(-)

