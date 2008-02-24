Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYBXR57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYBXR57 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 12:57:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYBXR5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 12:57:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45442 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYBXR5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 12:57:51 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 24 Feb 2008 18:56:10 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 0/5] firewire: fix crashes in workqueue jobs
To: linux1394-devel@lists.sourceforge.net
cc: Kristian Hoegsberg <krh@bitplanet.net>, Jarod Wilson <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
Message-ID: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here come 3 fixes + 2 cleanups.

 1/5 firewire: invalid pointers used in fw_card_bm_work
 2/5 firewire: fix crash in automatic module unloading
 3/5 firewire: remove superfluous reference counting
 4/5 firewire: fw-sbp2: fix reference counting
 5/5 firewire: refactor fw_unit reference counting

The main theme is that the firewire-core module has to stay loaded until
after all workqueue jobs of the core and of protocol drivers have been
finished.  This is accomplished by tracking the sum of references to
instances of fw_device for each card.  (As a side effect, we don't need
to count references to instances of fw_card anymore.)

 drivers/firewire/fw-card.c        |   99 ++++++++++++++++----------------------
 drivers/firewire/fw-device.c      |   21 ++------
 drivers/firewire/fw-device.h      |   35 ++++++++++---
 drivers/firewire/fw-ohci.c        |    8 +--
 drivers/firewire/fw-sbp2.c        |    9 ++-
 drivers/firewire/fw-topology.c    |    1
 drivers/firewire/fw-transaction.h |    6 --
 7 files changed, 89 insertions(+), 90 deletions(-)
-- 
Stefan Richter
-=====-==--- --=- ==---
http://arcgraph.de/sr/

