Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZJ0OBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZJ0OBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755033AbZJ0OBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:01:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:55751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754345AbZJ0OBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:01:22 -0400
Date: Tue, 27 Oct 2009 14:00:34 GMT
From: tip-bot for Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andreas.herrmann3@amd.com, herrmann.der.user@googlemail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, herrmann.der.user@googlemail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091027100138.GB30802@alberich.amd.com>
References: <20091027100138.GB30802@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Clear APIC Timer Initial Count Register on shutdown
Message-ID: <tip-6f9b41006af1bc489030f84ee247abc0df1edccd@git.kernel.org>
Git-Commit-ID: 6f9b41006af1bc489030f84ee247abc0df1edccd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f9b41006af1bc489030f84ee247abc0df1edccd
Gitweb:     http://git.kernel.org/tip/6f9b41006af1bc489030f84ee247abc0df1edccd
Author:     Andreas Herrmann <herrmann.der.user@googlemail.com>
AuthorDate: Tue, 27 Oct 2009 11:01:38 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 27 Oct 2009 14:54:21 +0100

x86, apic: Clear APIC Timer Initial Count Register on shutdown

Commit a98f8fd24fb24fcb9a359553e64dd6aac5cf4279 (x86: apic reset
counter on shutdown) set the counter to max to avoid spurious
interrupts when the timer is re-enabled.

(In theory) you'll still get a spurious interrupt if spending
more than 344 seconds with this interrupt disabled and then
unmasking it.

The right thing to do is to clear the register. This disables
the interrupt from happening (at least it does on AMD hardware).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20091027100138.GB30802@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index dce93d4..4c689f4 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -444,7 +444,7 @@ static void lapic_timer_setup(enum clock_event_mode mode,
 		v = apic_read(APIC_LVTT);
 		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
 		apic_write(APIC_LVTT, v);
-		apic_write(APIC_TMICT, 0xffffffff);
+		apic_write(APIC_TMICT, 0);
 		break;
 	case CLOCK_EVT_MODE_RESUME:
 		/* Nothing to do here */
