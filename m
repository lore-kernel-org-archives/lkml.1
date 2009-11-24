Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbZKXBjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbZKXBjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 20:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757775AbZKXBjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 20:39:46 -0500
Received: from relay3.sgi.com ([192.48.152.1]:34565 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755576AbZKXBjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 20:39:46 -0500
Message-Id: <20091124013937.354595000@alcatraz.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 23 Nov 2009 19:39:37 -0600
From: Robin Holt <holt@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Robin Holt <holt@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org
Subject: [patch 0/8] x86: UV - XPC fixes with related support functionality V2.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The UV BIOS has been updated to implement some of our interface
functionality differently than originally expected.  These patches update
the kernel to the bios implementation and include a few minor bug fixes
which prevent us from doing significant testing on real hardware.

Changes from V1:

- Actually include the patch introducing the gru_read_gpa.  This
  was missed in the V1 submission.

- One additional BIOS change has the OS no longer passing blade
  to the BIOS when registering a message queue watchlist.

---

 arch/x86/include/asm/uv/bios.h          |   11 --------
 arch/x86/include/asm/uv/uv_hub.h        |   20 +++++++++++++++
 arch/x86/kernel/bios_uv.c               |    8 +-----
 drivers/misc/sgi-gru/gru_instructions.h |   13 ++++++++++
 drivers/misc/sgi-gru/grukservices.c     |   23 +++++++++++++++++
 drivers/misc/sgi-gru/grukservices.h     |   14 ++++++++++
 drivers/misc/sgi-gru/gruprocfs.c        |    1 
 drivers/misc/sgi-gru/grutables.h        |    1 
 drivers/misc/sgi-xp/xp.h                |    1 
 drivers/misc/sgi-xp/xp_main.c           |    3 ++
 drivers/misc/sgi-xp/xp_sn2.c            |   10 +++++++
 drivers/misc/sgi-xp/xp_uv.c             |   33 +++++++++++++++++++++++++
 drivers/misc/sgi-xp/xpc_partition.c     |   13 +++++++---
 drivers/misc/sgi-xp/xpc_uv.c            |   41 +++++++++++++++++---------------
 14 files changed, 153 insertions(+), 39 deletions(-)
