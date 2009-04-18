Return-Path: <linux-kernel-owner+w=401wt.eu-S1755092AbZDRVCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092AbZDRVCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 17:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZDRVCm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 17:02:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:38479 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754034AbZDRVCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 17:02:40 -0400
Date: Sat, 18 Apr 2009 21:02:02 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, gorcunov@gmail.com,
       mingo@elte.hu
In-Reply-To: <20090418194528.GD25510@lenovo>
References: <20090418194528.GD25510@lenovo>
Subject: [tip:x86/apic] x86: smpboot - wakeup_secondary should be done via __cpuinit section
Message-ID: <tip-1f51f72326c4d16f402bdfed99c8dae20eb67863@git.kernel.org>
Git-Commit-ID: 1f51f72326c4d16f402bdfed99c8dae20eb67863
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 18 Apr 2009 21:02:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f51f72326c4d16f402bdfed99c8dae20eb67863
Gitweb:     http://git.kernel.org/tip/1f51f72326c4d16f402bdfed99c8dae20eb67863
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Sat, 18 Apr 2009 23:45:28 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 18 Apr 2009 22:58:58 +0200

x86: smpboot - wakeup_secondary should be done via __cpuinit section

A caller (do_boot_cpu) already has __cpuinit attribute.

Since HOTPLUG_CPU depends on SMP && HOTPLUG it doesn't
lead to panic at moment.

[ Impact: cleanup ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090418194528.GD25510@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/smpboot.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bf8ad63..d2e8de9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -504,7 +504,7 @@ void __inquire_remote_apic(int apicid)
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-int __devinit
+int __cpuinit
 wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -538,7 +538,7 @@ wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 	return (send_status | accept_status);
 }
 
-static int __devinit
+static int __cpuinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
