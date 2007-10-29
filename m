Return-Path: <linux-kernel-owner+w=401wt.eu-S1758777AbXJ2P6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777AbXJ2P6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 11:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755940AbXJ2P6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 11:58:16 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:37120 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755654AbXJ2P6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 11:58:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAOafJUdMQWvU/2dsb2JhbACBWg
Date: Mon, 29 Oct 2007 11:58:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Philippe Elie <phil.el@wanadoo.fr>
Subject: [patch 01/10] Move oprofile to arch/*/instrumentation
Message-ID: <20071029155810.GA20249@Krystal>
References: <20071029142646.699058449@polymtl.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20071029142646.699058449@polymtl.ca>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:56:09 up 91 days, 16:15,  3 users,  load average: 1.08, 1.18, 1.05
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is way too big for LKML (524k). I'll split it into each
different architectures for next submission.

Here is the changelog:

Move oprofile to arch/*/instrumentation

- Move oprofile to arch/*/instrumentation
- Fix per architecture Makefiles to follow this change
- Did _not_ fix whitespaces in oprofile so the file move is easy to follow.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Philippe Elie <phil.el@wanadoo.fr>
---
 arch/alpha/Makefile                               |    2 
 arch/alpha/instrumentation/Makefile               |   19 
 arch/alpha/instrumentation/common.c               |  189 +++
 arch/alpha/instrumentation/op_impl.h              |   55 
 arch/alpha/instrumentation/op_model_ev4.c         |  116 ++
 arch/alpha/instrumentation/op_model_ev5.c         |  211 +++
 arch/alpha/instrumentation/op_model_ev6.c         |  103 +
 arch/alpha/instrumentation/op_model_ev67.c        |  263 ++++
 arch/alpha/oprofile/Makefile                      |   19 
 arch/alpha/oprofile/common.c                      |  189 ---
 arch/alpha/oprofile/op_impl.h                     |   55 
 arch/alpha/oprofile/op_model_ev4.c                |  116 --
 arch/alpha/oprofile/op_model_ev5.c                |  211 ---
 arch/alpha/oprofile/op_model_ev6.c                |  103 -
 arch/alpha/oprofile/op_model_ev67.c               |  263 ----
 arch/arm/Makefile                                 |    2 
 arch/arm/instrumentation/Makefile                 |   13 
 arch/arm/instrumentation/backtrace.c              |   81 +
 arch/arm/instrumentation/common.c                 |  179 +++
 arch/arm/instrumentation/op_arm_model.h           |   34 
 arch/arm/instrumentation/op_counter.h             |   27 
 arch/arm/instrumentation/op_model_arm11_core.c    |  162 ++
 arch/arm/instrumentation/op_model_arm11_core.h    |   45 
 arch/arm/instrumentation/op_model_mpcore.c        |  303 +++++
 arch/arm/instrumentation/op_model_mpcore.h        |   61 +
 arch/arm/instrumentation/op_model_v6.c            |   67 +
 arch/arm/instrumentation/op_model_xscale.c        |  441 ++++++++
 arch/arm/oprofile/Makefile                        |   13 
 arch/arm/oprofile/backtrace.c                     |   81 -
 arch/arm/oprofile/common.c                        |  179 ---
 arch/arm/oprofile/op_arm_model.h                  |   34 
 arch/arm/oprofile/op_counter.h                    |   27 
 arch/arm/oprofile/op_model_arm11_core.c           |  162 --
 arch/arm/oprofile/op_model_arm11_core.h           |   45 
 arch/arm/oprofile/op_model_mpcore.c               |  303 -----
 arch/arm/oprofile/op_model_mpcore.h               |   61 -
 arch/arm/oprofile/op_model_v6.c                   |   67 -
 arch/arm/oprofile/op_model_xscale.c               |  441 --------
 arch/avr32/Makefile                               |    1 
 arch/avr32/instrumentation/Makefile               |    3 
 arch/blackfin/Makefile                            |    3 
 arch/blackfin/instrumentation/Makefile            |   14 
 arch/blackfin/instrumentation/common.c            |  168 +++
 arch/blackfin/instrumentation/op_blackfin.h       |   98 +
 arch/blackfin/instrumentation/op_model_bf533.c    |  161 ++
 arch/blackfin/instrumentation/timer_int.c         |   73 +
 arch/blackfin/oprofile/Makefile                   |   14 
 arch/blackfin/oprofile/common.c                   |  168 ---
 arch/blackfin/oprofile/op_blackfin.h              |   98 -
 arch/blackfin/oprofile/op_model_bf533.c           |  161 --
 arch/blackfin/oprofile/timer_int.c                |   73 -
 arch/i386/Makefile                                |    2 
 arch/ia64/Makefile                                |    2 
 arch/ia64/instrumentation/Makefile                |   10 
 arch/ia64/instrumentation/backtrace.c             |  150 ++
 arch/ia64/instrumentation/init.c                  |   38 
 arch/ia64/instrumentation/perfmon.c               |   99 +
 arch/ia64/oprofile/Makefile                       |   10 
 arch/ia64/oprofile/backtrace.c                    |  150 --
 arch/ia64/oprofile/init.c                         |   38 
 arch/ia64/oprofile/perfmon.c                      |   99 -
 arch/m32r/Makefile                                |    2 
 arch/m32r/instrumentation/Makefile                |    9 
 arch/m32r/instrumentation/init.c                  |   22 
 arch/m32r/oprofile/Makefile                       |    9 
 arch/m32r/oprofile/init.c                         |   22 
 arch/mips/Makefile                                |    2 
 arch/mips/instrumentation/Makefile                |   17 
 arch/mips/instrumentation/common.c                |  123 ++
 arch/mips/instrumentation/op_impl.h               |   40 
 arch/mips/instrumentation/op_model_mipsxx.c       |  348 ++++++
 arch/mips/instrumentation/op_model_rm9000.c       |  138 ++
 arch/mips/oprofile/Makefile                       |   17 
 arch/mips/oprofile/common.c                       |  123 --
 arch/mips/oprofile/op_impl.h                      |   40 
 arch/mips/oprofile/op_model_mipsxx.c              |  348 ------
 arch/mips/oprofile/op_model_rm9000.c              |  138 --
 arch/parisc/Makefile                              |    2 
 arch/parisc/instrumentation/Makefile              |    9 
 arch/parisc/instrumentation/init.c                |   23 
 arch/parisc/oprofile/Makefile                     |    9 
 arch/parisc/oprofile/init.c                       |   23 
 arch/powerpc/Makefile                             |    2 
 arch/powerpc/instrumentation/Makefile             |   19 
 arch/powerpc/instrumentation/backtrace.c          |  127 ++
 arch/powerpc/instrumentation/common.c             |  232 ++++
 arch/powerpc/instrumentation/op_model_7450.c      |  212 +++
 arch/powerpc/instrumentation/op_model_cell.c      | 1211 ++++++++++++++++++++++
 arch/powerpc/instrumentation/op_model_fsl_booke.c |  371 ++++++
 arch/powerpc/instrumentation/op_model_pa6t.c      |  240 ++++
 arch/powerpc/instrumentation/op_model_power4.c    |  317 +++++
 arch/powerpc/instrumentation/op_model_rs64.c      |  224 ++++
 arch/powerpc/oprofile/Makefile                    |   19 
 arch/powerpc/oprofile/backtrace.c                 |  127 --
 arch/powerpc/oprofile/common.c                    |  232 ----
 arch/powerpc/oprofile/op_model_7450.c             |  212 ---
 arch/powerpc/oprofile/op_model_cell.c             | 1211 ----------------------
 arch/powerpc/oprofile/op_model_fsl_booke.c        |  371 ------
 arch/powerpc/oprofile/op_model_pa6t.c             |  240 ----
 arch/powerpc/oprofile/op_model_power4.c           |  317 -----
 arch/powerpc/oprofile/op_model_rs64.c             |  224 ----
 arch/ppc/Makefile                                 |    2 
 arch/s390/Makefile                                |    2 
 arch/s390/instrumentation/Makefile                |    9 
 arch/s390/instrumentation/backtrace.c             |   79 +
 arch/s390/instrumentation/init.c                  |   26 
 arch/s390/oprofile/Makefile                       |    9 
 arch/s390/oprofile/backtrace.c                    |   79 -
 arch/s390/oprofile/init.c                         |   26 
 arch/sh/Makefile                                  |    2 
 arch/sh/instrumentation/Makefile                  |   17 
 arch/sh/instrumentation/op_model_null.c           |   23 
 arch/sh/instrumentation/op_model_sh7750.c         |  281 +++++
 arch/sh/oprofile/Makefile                         |   17 
 arch/sh/oprofile/op_model_null.c                  |   23 
 arch/sh/oprofile/op_model_sh7750.c                |  281 -----
 arch/sh64/Makefile                                |    2 
 arch/sh64/instrumentation/Makefile                |   12 
 arch/sh64/instrumentation/op_model_null.c         |   23 
 arch/sh64/oprofile/Makefile                       |   12 
 arch/sh64/oprofile/op_model_null.c                |   23 
 arch/sparc/Makefile                               |    2 
 arch/sparc/instrumentation/Makefile               |    9 
 arch/sparc/instrumentation/init.c                 |   23 
 arch/sparc/oprofile/Makefile                      |    9 
 arch/sparc/oprofile/init.c                        |   23 
 arch/sparc64/Makefile                             |    2 
 arch/sparc64/instrumentation/Makefile             |    9 
 arch/sparc64/instrumentation/init.c               |   23 
 arch/sparc64/oprofile/Makefile                    |    9 
 arch/sparc64/oprofile/init.c                      |   23 
 arch/x86/instrumentation/Makefile                 |   12 
 arch/x86/instrumentation/backtrace.c              |   91 +
 arch/x86/instrumentation/init.c                   |   48 
 arch/x86/instrumentation/nmi_int.c                |  477 ++++++++
 arch/x86/instrumentation/nmi_timer_int.c          |   69 +
 arch/x86/instrumentation/op_counter.h             |   29 
 arch/x86/instrumentation/op_model_athlon.c        |  180 +++
 arch/x86/instrumentation/op_model_p4.c            |  722 +++++++++++++
 arch/x86/instrumentation/op_model_ppro.c          |  192 +++
 arch/x86/instrumentation/op_x86_model.h           |   51 
 arch/x86/oprofile/Makefile                        |   12 
 arch/x86/oprofile/backtrace.c                     |   91 -
 arch/x86/oprofile/init.c                          |   48 
 arch/x86/oprofile/nmi_int.c                       |  477 --------
 arch/x86/oprofile/nmi_timer_int.c                 |   69 -
 arch/x86/oprofile/op_counter.h                    |   29 
 arch/x86/oprofile/op_model_athlon.c               |  180 ---
 arch/x86/oprofile/op_model_p4.c                   |  722 -------------
 arch/x86/oprofile/op_model_ppro.c                 |  192 ---
 arch/x86/oprofile/op_x86_model.h                  |   51 
 arch/x86_64/Makefile                              |    2 
 152 files changed, 9287 insertions(+), 9284 deletions(-)

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
