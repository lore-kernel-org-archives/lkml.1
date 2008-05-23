Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbYEWNrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbYEWNrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbYEWNoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:44:25 -0400
Received: from gw.goop.org ([64.81.55.164]:53253 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753829AbYEWNoU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:44:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 12 of 12] hrtimer: remove warning in hres_timers_resume
X-Mercurial-Node: 34ec53e89a83ff58aa513ce1629f813eda72de17
Message-Id: <34ec53e89a83ff58aa51.1211550079@localhost>
In-Reply-To: <patchbomb.1211550067@localhost>
Date: Fri, 23 May 2008 14:41:19 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hres_timers_resume() warns if there appears to be more than one cpu
online.  This warning makes sense when the suspend/resume mechanism
offlines all cpus but one during the suspend/resume process.

However, Xen suspend does not need to offline the other cpus; it
merely keeps them tied up in stop_machine() while the virtual machine
is suspended.  The warning hres_timers_resume issues is therefore
spurious.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 kernel/hrtimer.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -632,8 +632,6 @@
  */
 void hres_timers_resume(void)
 {
-	WARN_ON_ONCE(num_online_cpus() > 1);
-
 	/* Retrigger the CPU local events: */
 	retrigger_next_event(NULL);
 }


