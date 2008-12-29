Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbYL2Lvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbYL2Lvd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 06:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYL2LvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 06:51:23 -0500
Received: from monster.nessie.de ([84.200.20.120]:46104 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746AbYL2LvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 06:51:22 -0500
Message-ID: <4958B9B7.8060505@nessie.de>
Date: Mon, 29 Dec 2008 12:51:19 +0100
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.18 (X11/20081123)
MIME-Version: 1.0
To: Andrew Drake <zappacky.lists@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Funny problem with 2.6.28: Kernel stalls
References: <4953A35C.8090005@nessie.de> <495411FD.60409@gmail.com>
In-Reply-To: <495411FD.60409@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Drake schrieb:
> Michael Roth wrote:
>> The funny part: If I hit any key (on the keyboard connected by USB) the
>> kernel resumes to normal work until the next stall.
>>
> 
> This sounds a little bit like my old problem... try kernel option nolapic_timer.
> It worked for me, perhaps it can do the same for you.

I didn't checked nolapic_timer (yet), but found these small changes to
the kernel config do the trick for me:


--- config-not-working  2008-12-28 16:09:29.000000000 +0100
+++ .config     2008-12-28 16:15:28.000000000 +0100
@@ -153,9 +153,8 @@
 #
 # Processor type and features
 #
-CONFIG_TICK_ONESHOT=y
 # CONFIG_NO_HZ is not set
-CONFIG_HIGH_RES_TIMERS=y
+# CONFIG_HIGH_RES_TIMERS is not set
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 # CONFIG_SMP is not set
 # CONFIG_X86_MPPARSE is not set
@@ -278,7 +277,7 @@
 # CONFIG_HZ_300 is not set
 CONFIG_HZ_1000=y
 CONFIG_HZ=1000
-CONFIG_SCHED_HRTICK=y
+# CONFIG_SCHED_HRTICK is not set
 # CONFIG_KEXEC is not set
 # CONFIG_CRASH_DUMP is not set
 CONFIG_PHYSICAL_START=0x100000
