Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZLUIrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZLUIrf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 03:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbZLUIrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 03:47:35 -0500
Received: from lo.gmane.org ([80.91.229.12]:46968 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbZLUIre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 03:47:34 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: 2.6.33-rc1 build failure: copy_from_user() buffer size is not provably correct
Followup-To: gmane.linux.kernel
Date: Mon, 21 Dec 2009 14:04:40 +0530
Organization: RESEARCHUT
Message-ID: <0io307-9ti.ln1@news.researchut.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 202.3.120.9
User-Agent: KNode/4.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is triggered if using the 'allyesconfig' target.

A similar issue was this: 2886a8bdfa007053b414ab01741a98c18c376a85


debian-build:/tmp/all-yes-config/2.6.33-rc1# make deb-pkg
make KBUILD_SRC=                                         
  CHK     include/linux/version.h                        
  CHK     include/generated/utsrelease.h                 
  CALL    scripts/checksyscalls.sh                       
  CHK     include/generated/compile.h                    
  VDSOSYM arch/x86/vdso/vdso32-int80-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-sysenter-syms.lds
  VDSOSYM arch/x86/vdso/vdso32-syms.lds
  LD      arch/x86/vdso/built-in.o
  LD      arch/x86/built-in.o
  CC      mm/migrate.o
In file included from /tmp/all-yes-config/2.6.33-
rc1/arch/x86/include/asm/uaccess.h:571,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:6,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:62,
                 from include/linux/migrate.h:5,
                 from mm/migrate.c:15:
In function ‘copy_from_user’,
    inlined from ‘do_pages_stat’ at mm/migrate.c:1009:
/tmp/all-yes-config/2.6.33-rc1/arch/x86/include/asm/uaccess_32.h:213: error: 
call to ‘copy_from_user_overflow’ declared with attribute error: 
copy_from_user() buffer size is not provably correct
make[3]: *** [mm/migrate.o] Error 1
make[2]: *** [mm] Error 2
make[1]: *** [deb-pkg] Error 2
make: *** [deb-pkg] Error 2


Regards,
Ritesh
-- 
Given the large number of mailing lists I follow, I request you to CC me
in replies for quicker response

