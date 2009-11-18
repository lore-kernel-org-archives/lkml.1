Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbZKROkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbZKROkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZKROkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:40:23 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36881 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757295AbZKROkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:40:22 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [RFC PATCH 0/5] tty BKL pushdown
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:23:58 +0000
Message-ID: <20091118142313.3806.47368.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First steps to pushing the BKL down further into the tty layer. For review and
analysis not application !

---

Alan Cox (5):
      tty: split the lock up a bit further
      tty: Move the leader test in disassociate
      tty: Push the bkl down a bit in the hangup code
      tty: Push the lock down further into the ldisc code
      tty: push the BKL down into the handlers a bit


 drivers/char/pty.c       |    2 -
 drivers/char/tty_io.c    |  150 ++++++++++++++++++++++++++--------------------
 drivers/char/tty_ldisc.c |   23 ++++++-
 include/linux/tty.h      |    2 -
 kernel/exit.c            |    2 -
 5 files changed, 109 insertions(+), 70 deletions(-)
