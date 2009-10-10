Return-Path: <linux-kernel-owner+w=401wt.eu-S934859AbZJJUw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934859AbZJJUw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934849AbZJJUw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:52:27 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.45]:47429 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934809AbZJJUwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:52:11 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, Bernhard Walle <bernhard@bwalle.de>
Subject: Always print panic message on current console
Date: Sat, 10 Oct 2009 22:51:05 +0200
Message-Id: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.6.3.3
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the possibility to
redirect the kernel messages to a specific console.

However, since it's not possible to switch to the kernel message console after
a panic(), it would be nice if the kernel would print the panic message on the
current console.

As suggested by Andrew, this patch series adds a new interface to access
the global kmsg_redirect variable by a function to be able to use it in
code where CONFIG_VT_CONSOLE is not set (kernel/panic.c).

The patch series makes kmsg_redirect a static variable and all kernel
code outside of vt.c accesses that variable by the vt_set_kmsg_redirect()
and vt_get_kmsg_redirect() functions.


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>

---
 drivers/char/vt.c      |   41 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/tty.h    |    2 --
 include/linux/vt.h     |   18 ++++++++++++++++++
 kernel/panic.c         |    4 ++++
 kernel/power/console.c |    8 ++++----
 5 files changed, 66 insertions(+), 7 deletions(-)


