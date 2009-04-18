Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZDRTpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZDRTpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZDRTpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:45:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:60120 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZDRTpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Rvu4sUK+p4OL1N+Smuk11m01ZnAiToW2pTlwXq+tH1subiJpG9oZbfznUhFJKEZHxW
         D6GVV+JCgzlqlSrgcLUz1RZnIu83yn5aANeISiA2Ee1E3grZdw0CYwITUX+hQsBqLcNj
         nQPKZom5BWxmQxzbON1YXZIOj4kCRkY+HHkB4=
Date: Sat, 18 Apr 2009 23:45:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH -tip] x86: smpboot - wakeup_secondary should be done via
	__cpuinit section
Message-ID: <20090418194528.GD25510@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A caller (do_boot_cpu) already has __cpuinit attribute.

Since HOTPLUG_CPU depends on SMP && HOTPLUG it doesn't
lead to panic at moment.

[ Impact: cleanup ]

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/smpboot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/smpboot.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6.git/arch/x86/kernel/smpboot.c
@@ -504,7 +504,7 @@ void __inquire_remote_apic(int apicid)
  * INIT, INIT, STARTUP sequence will reset the chip hard for us, and this
  * won't ... remember to clear down the APIC, etc later.
  */
-int __devinit
+int __cpuinit
 wakeup_secondary_cpu_via_nmi(int logical_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
@@ -538,7 +538,7 @@ wakeup_secondary_cpu_via_nmi(int logical
 	return (send_status | accept_status);
 }
 
-static int __devinit
+static int __cpuinit
 wakeup_secondary_cpu_via_init(int phys_apicid, unsigned long start_eip)
 {
 	unsigned long send_status, accept_status = 0;
