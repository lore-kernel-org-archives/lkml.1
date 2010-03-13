Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0CMGuA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 01:50:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49229 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab0CMGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 01:49:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=M3AYTLZmLAMnr/4MV+dPsnN5TYfmTKC56sd7QONptzEOGIWbnauD9A/mqMwD3gOcXm
         0oV9+Mv1bqQgw1aZB+aJXTq/uPOqXQ8EJHXRz+3D1UteKb9HqyX5Az9JSF8lQ+hx1DQn
         wPUmkVpBSFXQDLIseRkxhnuqwVq3gfxO6pWpY=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 00/10] ARM: ftrace: cleanups, Thumb-2, and dynamic ftrace (v2)
Date: Sat, 13 Mar 2010 12:19:37 +0530
Message-Id: <1268462987-8271-1-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: Fixes as per review comments.  The only code changes are the #error in 0004
and the removal of the #ifdef in 0009.  The rest are comments and commit
message rewording/expansion.

This series contains fixes and improvements to the ARM ftrace support.  It adds
Thumb-2 support and re-implements the dynamic ftrace support.

"ftrace: allow building without frame pointers" and "ftrace: pass KBUILD_CFLAGS
to record_mcount.pl" are non-ARM-specific ftrace patches which are required to
support the ARM functionality.

Cleanups / docs:

  ARM: ftrace: clean up mcount assembly indentation
  ARM: ftrace: document mcount formats

Thumb-2:

  ftrace: allow building without frame pointers
  ARM: ftrace: allow building without frame pointers
  ARM: ftrace: add ENDPROC annotations
  ARM: ftrace: add Thumb-2 support

Dynamic ftrace:

  ftrace: pass KBUILD_CFLAGS to record_mcount.pl
  ARM: ftrace: fix and update dynamic ftrace
  ARM: ftrace: add Thumb-2 support to dynamic ftrace
  ARM: ftrace: enable dynamic ftrace

 Makefile                       |    7 ++
 arch/arm/Kconfig               |    2 +
 arch/arm/Kconfig.debug         |    5 +
 arch/arm/include/asm/ftrace.h  |   20 ++++-
 arch/arm/kernel/armksyms.c     |    2 +
 arch/arm/kernel/entry-common.S |  178 +++++++++++++++++++++++++++-----------
 arch/arm/kernel/ftrace.c       |  188 +++++++++++++++++++++++++++++----------
 kernel/trace/Kconfig           |    2 +-
 scripts/Makefile.build         |    3 +-
 scripts/recordmcount.pl        |    2 +
 10 files changed, 307 insertions(+), 102 deletions(-)

