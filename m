Return-Path: <linux-kernel-owner+w=401wt.eu-S1759880AbXHVKQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880AbXHVKQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 06:16:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbXHVKPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 06:15:54 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1853 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755146AbXHVKPy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 06:15:54 -0400
Date: Wed, 22 Aug 2007 14:15:29 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: roland@redhat.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: 2.6.23-rc3-mm1: cannot stat `vdso.so.dbg'
Message-ID: <20070822101529.GE7228@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	# make V=1 modules_install install
	make -f scripts/Makefile.build obj=arch/x86_64/vdso install
	  cp vdso.so.dbg /lib/modules/2.6.23-rc3-mm1/vdso/vdso.so
	cp: cannot stat `vdso.so.dbg': No such file or directory
	make[1]: *** [vdso.so] Error 1
	make: *** [install] Error 2

However, it's in place looks like:

	# ls -l arch/x86_64/vdso/vdso*      
	-rw-r--r-- 1 ad ad  291 Aug 22 13:46 arch/x86_64/vdso/vdso-note.S
	-rw-r--r-- 1 ad ad  830 Aug 22 13:53 arch/x86_64/vdso/vdso-note.o
	-rw-r--r-- 1 ad ad   45 Aug 22 13:46 arch/x86_64/vdso/vdso-start.S
	-rw-r--r-- 1 ad ad  753 Aug 22 13:53 arch/x86_64/vdso/vdso-start.o
	-rw-r--r-- 1 ad ad 3257 Aug 22 13:53 arch/x86_64/vdso/vdso-syms.o
	-rw-r--r-- 1 ad ad   58 Aug 22 13:46 arch/x86_64/vdso/vdso.S
	-rw-r--r-- 1 ad ad 2150 Aug 22 13:53 arch/x86_64/vdso/vdso.lds
	-rw-r--r-- 1 ad ad 2163 Aug 22 13:46 arch/x86_64/vdso/vdso.lds.S
	-rw-r--r-- 1 ad ad 4905 Aug 22 13:53 arch/x86_64/vdso/vdso.o
	-rw-r--r-- 1 ad ad 4104 Aug 22 13:53 arch/x86_64/vdso/vdso.so
===>	-rwxr-xr-x 1 ad ad 5482 Aug 22 13:53 arch/x86_64/vdso/vdso.so.dbg

