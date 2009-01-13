Return-Path: <linux-kernel-owner+w=401wt.eu-S1757619AbZAMD0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757619AbZAMD0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbZAMD03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:26:29 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:46246 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbZAMD03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:26:29 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2009 22:26:28 EST
Message-ID: <496C091E.1000003@oracle.com>
Date: Tue, 13 Jan 2009 11:23:10 +0800
From: Wenji Huang <wenji.huang@oracle.com>
Reply-To: wenji.huang@oracle.com
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kbuild@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Building error of 2.6.29-rc1 using old binutils
References: <4922238C.40807@oracle.com> <20081122114329.GB24848@uranus.ravnborg.org> <496C06D0.3060903@oracle.com>
In-Reply-To: <496C06D0.3060903@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.496C09DF.014B:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry, resend it in terms of correct subject.

I got the following building error for 2.6.29-rc1.
# make
   CHK     include/linux/version.h
   CHK     include/linux/utsrelease.h
   SYMLINK include/asm -> include/asm-x86
   CALL    scripts/checksyscalls.sh
   CHK     include/linux/compile.h
   IHEX    firmware/e100/d101m_ucode.bin
   AS      firmware/e100/d101m_ucode.bin.gen.o
   IHEX    firmware/e100/d101s_ucode.bin
   AS      firmware/e100/d101s_ucode.bin.gen.o
   IHEX    firmware/e100/d102e_ucode.bin
   AS      firmware/e100/d102e_ucode.bin.gen.o
   LD      firmware/built-in.o
   LD      vmlinux.o
   MODPOST vmlinux.o
   GEN     .version
   CHK     include/linux/compile.h
   UPD     include/linux/compile.h
   CC      init/version.o
   LD      init/built-in.o
   LD      .tmp_vmlinux1
   STRIP   .tmp_vmlinux1.stripped
objcopy: unrecognized option `--strip-unneeded-symbols'

# objcopy --version
GNU objcopy 2.15.92.0.2 20040927
Copyright 2004 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms 
of the GNU General Public License.  This program has absolutely no warranty.


The option --strip-unneeded-symbols is only available on higher version, 
but not exists on binutils-2.15.

Seems to keep Makefile compatible on all kinds of circumstances. Like,

quiet_cmd_kstrip = STRIP   $@
       cmd_kstrip = $(OBJCOPY) --wildcard $(addprefix --strip-symbols 
,$(filter %/scripts/strip-symbols,$^)) $< $@


Regards,
Wenji


