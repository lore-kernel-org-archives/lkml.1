Return-Path: <linux-kernel-owner+w=401wt.eu-S936440AbXGQUqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936440AbXGQUqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 16:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935821AbXGQUmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 16:42:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934872AbXGQUml convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 16:42:41 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Resend][PATCH 0/9] PM: Update global suspend and hibernation operations framework
Date: Tue, 17 Jul 2007 22:36:27 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, Len Brown <len.brown@intel.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Shaohua Li <shaohua.li@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Paul Mackerras <paulus@samba.org>, Russell King <rmk@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707172236.28895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches implements changes that are possible/necessary/desirable
(IMO) after the introduction of the .set_target() method in 'struct pm_ops' (commit
2391dae3e36c19fe668c71eac2eb8344dbaaf46d).

The patches in the series make the following changes:
* make ACPI use the new .set_target() method in 'struct pm_ops'
* add an ACPI helper function for the devices to determine the power state
  to put the device into
* move the definition of 'struct pm_ops' to <include/suspend.h>
* change the name of 'struct pm_ops' to 'struct platform_suspend_ops' and
  modify the names of some related functions and global variables accordingly
* modify 'struct platform_suspend_ops' so that .prepare() and .finish() don't
  take arguments (.enter() still takes the state argument, because some
  platforms don't need to implement the other callbacks)
* make some functions normally defined in kernel/power/main.c be also defined
  when CONFIG_PM is unset
* make suspend_ops be a static variable
* rework 'struct hibernation_ops' to add the new method analogous to
  .set_target()
* rename 'struct hibernation_ops' to 'struct platform_hibernation_ops' (in
  analogy with 'struct platform_suspend_ops')

The series in on top of the current -git with the following patches, currently
in -mm or in the ACPI tree, applied:

swsusp-remove-incorrect-code-from-userc.patch
swsusp-remove-code-duplication-between-diskc-and-userc.patch
swsusp-introduce-restore-platform-operations.patch
swsusp-fix-hibernation-code-ordering.patch
hibernation-prepare-to-enter-the-low-power-state.patch
pm-introduce-hibernation-and-suspend-notifiers.patch
acpi-do-not-attempt-to-run-s1-standby-workarounds-while-hibernating.patch
pm-reduce-code-duplication-between-mainc-and-userc-updated.patch

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

