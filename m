Return-Path: <linux-kernel-owner+w=401wt.eu-S1754029Ab0A0UEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab0A0UEK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671Ab0A0UEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:04:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753556Ab0A0UEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:04:08 -0500
From: Don Zickus <dzickus@redhat.com>
To: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com
Cc: aris@redhat.com, linux-kernel@vger.kernel.org,
       Don Zickus <dzickus@redhat.com>
Subject: [PATCH 0/3] [RFC] new nmi_watchdog using perf events
Date: Wed, 27 Jan 2010 15:03:39 -0500
Message-Id: <1264622622-5778-1-git-send-email-dzickus@redhat.com>
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

Cheers,
Don

--
Sorry if this spams people again.  My mailer was broke and some mail wasn't
sent correctly.

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

