Return-Path: <linux-kernel-owner+w=401wt.eu-S1754603AbZG2WF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbZG2WF7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 18:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZG2WF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 18:05:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49861 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbZG2WF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 18:05:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] PM fixes for 2.6.31
Date: Thu, 30 Jul 2009 00:06:03 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, stable@kernel.org,
       linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907300006.04751.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management fixes for 2.6.31 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-fixes

This will fix two regressions, one related to the handling of the
ACPI SCI_EN bit during resume from suspend to RAM (machine with a
broken BIOS has to be blacklisted) and the other caused by
putting bdget() under a spinlock in the hibernation code.

 drivers/acpi/sleep.c |    8 ++++++++
 fs/block_dev.c       |   10 ++++++++++
 include/linux/fs.h   |    1 +
 mm/swapfile.c        |    4 ++--
 4 files changed, 21 insertions(+), 2 deletions(-)

---------------

Alan Jenkins (1):
      PM / Hibernate: Replace bdget call with simple atomic_inc of i_count

Bartlomiej Zolnierkiewicz (1):
      PM / ACPI: HP G7000 Notebook needs a SCI_EN resume quirk

