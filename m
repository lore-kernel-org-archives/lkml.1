Return-Path: <linux-kernel-owner+w=401wt.eu-S1758956AbYEYTlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956AbYEYTlJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbYEYTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:40:54 -0400
Received: from main.gmane.org ([80.91.229.2]:56326 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbYEYTkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:40:53 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Kernel checking options
Date: Sun, 25 May 2008 20:27:36 +0100
Message-ID: <g1cfbn$uic$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 87.113.14.160.plusnet.pte-ag1.dyn.plus.net
User-Agent: KNode/0.10.4
Cc: kernel-testers@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the recent drive for more testers I'm curious about options that can be
turned on that will do more checking/verification (as opposed to just
creating more debug output). 

Thus far I have come across the following that suggest that they will do
extra checks:

CONFIG_DEBUG_SHIRQ:
Tests whether drivers can handle spurious interrupts upon registration /
unregistration.

CONFIG_DETECT_SOFTLOCKUP:
Detects if the kernel spends more than 10 seconds in the kernel without
giving anything else a chance to run and prints a stacktrace.

CONFIG_DEBUG_OBJECTS:
Tracks the lifetime of various objects (what does this mean?) and validates
operations on those objects.

CONFIG_DEBUG_OBJECTS_SELFTEST:
Runs a self test on the object debug code.

CONFIG_DEBUG_OBJECTS_FREE:
Detects and reports whether memory freed with kmalloc / vmalloc still
contains an object that hasn't been properly deactivated.

CONFIG_DEBUG_OBJECTS_TIMERS:
Tracks the lifetime of timer objects (what does this mean?) and validates
timer operations.

CONFIG_SLUB_DEBUG_ON:
Boot with SLUB debugging on by default. Detects and reports when slub
objects have become corrupt. Can create guard zones around objects and
poison objects not currently in use.

CONFIG_DEBUG_RT_MUTEXES:
Detects and reports realtime mutex semantic violoations realtime mutex
related deadlocks.

CONFIG_DEBUG_SPINLOCK:
Detects missing spinlock initialisation and other common spinlock errors.
May need to be used with an NMI watchdog.

CONFIG_DEBUG_MUTEXES:
Detects and reports mutex semantics violations.

CONFIG_DEBUG_LOCK_ALLOC:
Detects and reports whether a held {spinlock, rwlock, mutex, rwsem} is being
incorrectly freed when memory is freed, whether a live lock is being
incorrectly reinitialised, or if a lock is still being held when a task
exits.

CONFIG_PROVE_LOCKING:
Detects and reports if a particular sequence of locks could lead to a
deadlock.

CONFIG_DEBUG_LOCKDEP:
Do checks on the lock dependency engine.

CONFIG_DEBUG_SPINLOCK_SLEEP:
Certain routines (that can sleep) will be detected and reported if called
while a spinlock is held.

CONFIG_DEBUG_HIGHMEM:
Does additional error checking for high (1GByte or greater) memory systems.

CONFIG_DEBUG_VM:
Does extended checks on the virtual-memory system.

CONFIG_DEBUG_WRITECOUNT:
Detects and reports incorrect use of the writers count in struct vfsmount.

CONFIG_DEBUG_LIST:
Does extended checks on linked list walking routines.

CONFIG_DEBUG_SG:
Does checks on scatter-gather tables.

CONFIG_KERNEL_TESTS:
This enables the ability to select additional tests.

CONFIG_DEBUG_LOCKING_API_SELFTESTS:
Runs a self test on the lock dependency engine.

CONFIG_RT_MUTEX_TESTER:
Enables a rt-mutex tester.

CONFIG_BACKTRACE_SELF_TEST:
Runs a self test on the backtrace code.

CONFIG_DEBUG_STACKOVERFLOW:
Detects and reports if the free stack space drops below a certain threshold.

CONFIG_DEBUG_PAGEALLOC:
Unmaps pages from the kernel linear mapping after free_pages() is called.

CONFIG_DEBUG_RODATA:
Marks kernel read only data as write protected. 

CONFIG_DEBUG_RODATA_TEST:
Runs a self test on the RODATA feature.

CONFIG_CPA_DEBUG:
Does a change_page_attr() self-test every 30 seconds.

CONFIG_X86_MCE:
Detect and reports if the hardware notices an anomaly in itself.

CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT:
Detects and warns if a driver hands mac80211 a buffer that is aligned in
that could cause a problem with the IP stack on some architectures.

CONFIG_SND_DEBUG:
Enable the ability to select ALSA debug code?

CONFIG_SND_PCM_XRUN_DEBUG:
Detects and reports PCM ring buffer overruns/underruns (e.g. due to
scheduling gaps).

Is this list complete? Are they all enabling additional checks?

Additionally are there any options that will make (real) bugs more likely to
occur? For example does preemption make bugs related to races (that could
happen without preemption) happen more often?

-- 
Sitsofe | http://sucs.org/~sits/

