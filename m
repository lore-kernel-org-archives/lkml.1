Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYBQPgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYBQPgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 10:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755207AbYBQPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 10:36:39 -0500
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:48053
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874AbYBQPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 10:36:39 -0500
Message-ID: <47B85485.2020000@qumranet.com>
Date: Sun, 17 Feb 2008 17:36:37 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>
Subject: 2.6.25-rc2, Problem running 'make install' as root with different
 gcc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trying to install a built 2.5.25-rc2 on a machine with a different gcc 
installed fails with

  LDS     arch/x86/vdso/vdso.lds
cc1: fatal error: opening output file arch/x86/vdso/vdso.lds: Permission 
denied
compilation terminated.
make[1]: *** [arch/x86/vdso/vdso.lds] Error 1
make: *** [vdso_install] Error 2

I believe this is due to arch/x86/vdso/.vdso.lds.cmd containing

cmd_arch/x86/vdso/vdso.lds := gcc -E -Wp,-MD,arch/x86/vdso/.vdso.lds.d  
-nostdinc -isystem /usr/lib/gcc/x86_64-redhat-linux/4.1.1/include 
-D__KERNEL__ -Iinclude  -include include/linux/autoconf.h   -P -C 
-D__ASSEMBLY__ -o arch/x86/vdso/vdso.lds arch/x86/vdso/vdso.lds.S

'-isystem /usr/lib/gcc/x86_64-redhat-linux/4.1.1/include' changes with 
the gcc version, triggering the recompilation attempt, which fails since 
my home directory is nfs mounted.

This didn't trigger with previous versions, and I have no idea how to 
fix it.

-- 
error compiling committee.c: too many arguments to function

