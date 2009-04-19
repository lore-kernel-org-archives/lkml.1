Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbZDSI2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbZDSI2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 04:28:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757036AbZDSI0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 04:26:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:55388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758386AbZDSI0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 04:26:38 -0400
Date: Sun, 19 Apr 2009 08:25:51 GMT
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
Message-ID: <tip-cece3155d869a50ba534ed161b5a05e8a29dcad0@git.kernel.org>
Git-Commit-ID: cece3155d869a50ba534ed161b5a05e8a29dcad0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 19 Apr 2009 08:25:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cece3155d869a50ba534ed161b5a05e8a29dcad0
Gitweb:     http://git.kernel.org/tip/cece3155d869a50ba534ed161b5a05e8a29dcad0
Author:     Cyrill Gorcunov <gorcunov@gmail.com>
AuthorDate: Sat, 18 Apr 2009 23:45:28 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 19 Apr 2009 10:22:14 +0200

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
