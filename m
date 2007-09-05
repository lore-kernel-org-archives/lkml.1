Return-Path: <linux-kernel-owner+w=401wt.eu-S1756690AbXIEJ1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690AbXIEJ1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 05:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756097AbXIEJ1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 05:27:45 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38702 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbXIEJ1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 05:27:44 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 5 Sep 2007 05:16:12 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: building a specific in-tree module is currently a bit broken
Message-ID: <Pine.LNX.4.64.0709050509150.27539@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	TW_VN 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  i know sam ravnborg has been Cc'ed on a janitors list posting
mentioning this but, just in case this note can get a fix snuck in
there quickly before 2.6.23 (this is on i386, but i'm guessing applies
to all arches):

$ make distclean
$ make defconfig
$ make menuconfig      (select visor.ko to be built a module)
$ make drivers/usb/serial/visor.ko
scripts/kconfig/conf -s arch/i386/Kconfig
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  CHK     include/linux/utsrelease.h
  UPD     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-i386
  CC      arch/i386/kernel/asm-offsets.s
  GEN     include/asm-i386/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/modpost.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/conmakehash
  HOSTCC  scripts/bin2c
  CC [M]  drivers/usb/serial/visor.o
/bin/sh: .tmp_versions/visor.mod: No such file or directory
  MODPOST 0 modules
$

  whoops.  manually creating the directory .tmp_versions first fixes
this, but i'm not conversant enough with the Makefile to want to take
a shot at repairing this.

rday

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
