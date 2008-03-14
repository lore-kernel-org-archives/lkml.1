Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYCNSJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYCNSJd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 14:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYCNSJZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 14:09:25 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45503 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbYCNSJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 14:09:25 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 14 Mar 2008 19:07:11 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [GIT PULL] FireWire updates
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.948f418ebe464164@s5r6.in-berlin.de>
Message-ID: <tkrat.b05a30e97b4f9820@s5r6.in-berlin.de>
References: <tkrat.459cc31de75e4149@s5r6.in-berlin.de>
 <tkrat.68585c2b7aee00eb@s5r6.in-berlin.de>
 <tkrat.14d846ed63cc91c2@s5r6.in-berlin.de>
 <tkrat.948f418ebe464164@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from the for-linus branch at

    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git for-linus

to receive the following updates for the firewire subsystem and one
regression fix for the ieee1394 subsystem.  They fix
  - I/O errors with firewire-sbp2 if the PCI bus became slightly busy,
  - I/O errors with some LSIL (ex Symbios) based targets (2.6.25-rc1
    regression in case of sbp2),
  - asynchronous reception on systems with memory outside cache-
    coherent range,
  - machine check exception when resuming or reloading firewire-ohci
    on PowerMacs, PowerBooks, iBooks,
  - split transactions with big endian CPUs.
There are also a small documentation update and sparse annotations in
there.

I consider this batch OK in this late -rc phase because the most
intrusive change was easy to test on a range of machines, and the other
changes are very local and were therefore also rather easy to verify and
test. The PPC PMac parts are already known to work from ohci1394.

I will follow up with a combined full log and diff.  Diffstat and
shortlog:

 drivers/firewire/Kconfig          |   50 +++++--------
 drivers/firewire/fw-ohci.c        |  108 +++++++++++++++++++++-------
 drivers/firewire/fw-sbp2.c        |   36 +++++++++-
 drivers/firewire/fw-topology.c    |    3 +-
 drivers/firewire/fw-transaction.c |    2 +-
 drivers/firewire/fw-transaction.h |    6 +-
 drivers/ieee1394/sbp2.c           |    5 ++
 7 files changed, 143 insertions(+), 67 deletions(-)

Jarod Wilson (2):
      firewire: fw-sbp2: set single-phase retry_limit
      firewire: fw-ohci: use dma_alloc_coherent for ar_buffer

Stefan Richter (9):
      firewire: endianess fix
      firewire: endianess annotations
      firewire: fw-ohci: PPC PMac platform code
      firewire: fw-ohci: Apple UniNorth 1st generation support
      firewire: warn on fatal condition in topology code
      firewire: update Kconfig help text
      firewire: fw-sbp2: fix for SYM13FW500 bridge (Datafab disk)
      ieee1394: sbp2: fix for SYM13FW500 bridge (Datafab disk)
      firewire: fw-ohci: shut up false compiler warning on PPC32

Thanks,
-- 
Stefan Richter
-=====-==--- --== -===-
http://arcgraph.de/sr/

