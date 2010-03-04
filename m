Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab0CDD5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:57:36 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46661 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0CDD5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:32 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>
Subject: [PATCH 00/14] Convert remaining arches to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:15 -0800
Message-Id: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of arches have moved over to using the generic read_persisitent_clock
or update_persisitent_clock implementations instead of manipulating xtime
themselves.

This patchset tries to convert the remaining arches over and will allow for
further generic timekeeping cleanups.

There is some issues where the RTC/persistent clock is behind a bus that requires
irqs to access. This patch is not trying to handle those cases, and instead is just
using whatever method was used at time_init to initialize xtime.

I sent this set out back in December to only a bit of discussion (many thanks to 
the testers who provided feedback!). But I wanted to send it out again to try to 
get this moving again.

Any feedback or comments would be appreciated.

thanks
-john


John Stultz (14):
  alpha: Convert alpha to use read/update_persistent_clock
  mn10300: Convert mn10300 to use read/update_persistent_clock
  frv: Convert frv to use read/update_persistent_clock
  parisc: Convert parisc to use read/update_persistent_clock
  h8300: Convert h8300 to use read/update_persistent_clock
  avr32: Convert avr32 to use read/update_persistent_clock
  ia64: Convert ia64 to use read/update_persistent_clock
  sh: Convert sh to use read/update_persistent_clock
  blackfin: Convert blackfin to use read/update_persistent_clock
  m32r: Convert m32r to use read/update_peristent_clock
  m68k: Convert m68k to use read/update_persistent_clock
  sparc: Convert sparc to use read/update_persistent_clock
  cris: Convert cris to use read/update_persistent_clock
  arm: Convert arm to use read_persistent_clock

 arch/alpha/Kconfig               |    3 +
 arch/alpha/kernel/time.c         |  101 ++++++++++++++++++--------------------
 arch/arm/Kconfig                 |    3 +
 arch/arm/kernel/time.c           |    7 +++
 arch/avr32/kernel/time.c         |   12 ++--
 arch/blackfin/kernel/time-ts.c   |   13 +++--
 arch/blackfin/kernel/time.c      |   39 ++------------
 arch/cris/Kconfig                |    3 +
 arch/cris/arch-v10/kernel/time.c |   37 +-------------
 arch/cris/arch-v32/kernel/time.c |   40 +--------------
 arch/cris/kernel/time.c          |   20 ++++---
 arch/frv/kernel/time.c           |   34 +++----------
 arch/h8300/kernel/time.c         |   10 +++-
 arch/ia64/kernel/time.c          |   12 ++---
 arch/m32r/kernel/time.c          |   47 +++---------------
 arch/m68k/kernel/time.c          |   11 +++--
 arch/mn10300/Kconfig             |    3 +
 arch/mn10300/kernel/rtc.c        |   27 ++--------
 arch/mn10300/kernel/time.c       |    4 --
 arch/parisc/kernel/time.c        |   29 +++++------
 arch/sh/kernel/time.c            |    6 +--
 arch/sparc/Kconfig               |    2 +-
 arch/sparc/kernel/time_32.c      |   15 ++----
 23 files changed, 158 insertions(+), 320 deletions(-)

