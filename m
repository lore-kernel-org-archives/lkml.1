Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136Ab0BFCrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 21:47:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933938Ab0BFCrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 21:47:36 -0500
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, peterz@infradead.org
Cc: gorcunov@gmail.com, aris@redhat.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3 v2] new nmi_watchdog using perf events
Date: Fri,  5 Feb 2010 21:47:02 -0500
Message-Id: <1265424425-31562-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series tries to implement a new nmi_watchdog using the perf
events subsystem.  I am posting this series early for feedback on the
approach.  It isn't feature compatible with the old nmi_watchdog yet, nor
does it have all the old workarounds either.

The basic design is to create an in-kernel performance counter that goes off
every few seconds and checks for cpu lockups.  It is fairly straight
forward.  Some of the quirks are making sure the cpu lockup detection works
correctly.

It has been lightly tested for now.  Once people are ok with the approach,
I'll expand testing to more machines in our lab.

I tried taking a generic approach so all arches could use it if they want
and then implement some per arch specific hooks.  I believe this is what
Ingo was suggesting.  The initial work is based off of kernel/softlockup.c.

Any feedback would be great.

v2:
- moved a notify_die call into a #ifdef block
- used better default values for configuring the nmi_watchdog based on
  the old nmi_watchdog values

Cheers,
Don

--
damn it forgot to cc lkml

Don Zickus (3):
  [RFC][x86] move notify_die from nmi.c to traps.c
  [RFC] nmi_watchdog: new implementation using perf events
  [RFC] nmi_watchdog: config option to enable new nmi_watchdog

 arch/x86/kernel/apic/Makefile |    7 ++-
 arch/x86/kernel/apic/hw_nmi.c |  114 ++++++++++++++++++++++++
 arch/x86/kernel/apic/nmi.c    |    7 --
 arch/x86/kernel/traps.c       |    7 ++
 include/linux/nmi.h           |    4 +
 kernel/Makefile               |    1 +
 kernel/nmi_watchdog.c         |  196 +++++++++++++++++++++++++++++++++++++++++
 lib/Kconfig.debug             |   13 +++
 8 files changed, 341 insertions(+), 8 deletions(-)
 create mode 100644 arch/x86/kernel/apic/hw_nmi.c
 create mode 100644 kernel/nmi_watchdog.c

