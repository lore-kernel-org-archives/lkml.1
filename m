Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbXKTAO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbXKTAO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:14:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752043AbXKTAOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:14:50 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbXKTAOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:14:50 -0500
Date: Mon, 19 Nov 2007 19:14:45 -0500
From: Dave Jones <davej@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Recursive variable `KBUILD_CFLAGS' references itself (eventually).
Message-ID: <20071120001445.GA9243@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Sam Ravnborg <sam@ravnborg.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to do a 32bit build on a 64bit machine.
I did..
  make ARCH=i386 oldconfig
  make ARCH=i386 arch/x86/

and got..

scripts/kconfig/conf -s arch/x86/Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/conmakehash
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  HOSTCC  scripts/bin2c
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm-x86/asm-offsets.h
  CALL    scripts/checksyscalls.sh
/mnt/raid0/src/linux-2.6/arch/x86/Makefile_32:43: *** Recursive variable `KBUILD_CFLAGS' references itself (eventually).  Stop.
make: *** [arch/x86/] Error 2


	Dave

-- 
http://www.codemonkey.org.uk
