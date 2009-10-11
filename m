Return-Path: <linux-kernel-owner+w=401wt.eu-S1752071AbZJKVFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbZJKVFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751442AbZJKVFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:05:48 -0400
Received: from smtprelay10.ispgateway.de ([80.67.29.24]:37618 "EHLO
	smtprelay10.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZJKVFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:05:48 -0400
From: Bernhard Walle <bernhard@bwalle.de>
To: akpm@linuxfoundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       Bernhard Walle <bernhard@bwalle.de>
Subject: Always print panic message on current console
Date: Sun, 11 Oct 2009 23:04:29 +0200
Message-Id: <1255295071-13664-1-git-send-email-bernhard@bwalle.de>
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

This patch series adds a new interface to access the global kmsg_redirect
variable by a function to be able to use it in code where CONFIG_VT_CONSOLE is
not set (kernel/panic.c).


Signed-off-by: Bernhard Walle <bernhard@bwalle.de>

---
 drivers/char/vt.c      |   43 +++++++++++++++++++++++++++++++++++++------
 include/linux/tty.h    |    2 --
 include/linux/vt.h     |   15 +++++++++++++++
 kernel/panic.c         |    4 ++++
 kernel/power/console.c |    7 +++----
 5 files changed, 59 insertions(+), 12 deletions(-)

