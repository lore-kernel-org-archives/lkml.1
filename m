Return-Path: <linux-kernel-owner+w=401wt.eu-S2992816AbXCHBZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992816AbXCHBZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 20:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992818AbXCHBZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 20:25:15 -0500
Received: from paf87.warszawa.sdi.tpnet.pl ([217.96.225.87]:42131 "EHLO
	qrnik.knm.org.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992816AbXCHBZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 20:25:13 -0500
X-Greylist: delayed 1618 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2007 20:25:13 EST
Subject: _proxy_pda still makes linking modules fail
From: "Marcin 'Qrczak' Kowalczyk" <qrczak@knm.org.pl>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Mar 2007 01:57:59 +0100
Message-Id: <1173315479.12472.9.camel@qrnik>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 PLD Linux 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is linux-2.6.20.1 with lots of patches from PLD Linux (I believe
the patches don't affect the issue), compiled with gcc-4.1.2 and
binutils-2.17.50.0.12 on x86.

Linking the kernel causes warnings:

  RELOCS  arch/i386/boot/compressed/vmlinux.relocs
WARNING: Absolute relocations present
Offset     Info     Type     Sym.Value Sym.Name
c0102cd7 00450601   R_386_32 00000000  _proxy_pda
c0104922 00450601   R_386_32 00000000  _proxy_pda
c0110623 00450601   R_386_32 00000000  _proxy_pda
c011bdc5 00450601   R_386_32 00000000  _proxy_pda
c0125fc1 00450601   R_386_32 00000000  _proxy_pda
c016c0e2 00450601   R_386_32 00000000  _proxy_pda
c016c2ab 00450601   R_386_32 00000000  _proxy_pda
c016f91c 00450601   R_386_32 00000000  _proxy_pda

Linking modules fails:

  Building modules, stage 2.
  MODPOST 1970 modules
WARNING: vmlinux - Section mismatch: reference to .init.data:boot_params from .text between '_text' (at offset 0xc0100036) and 'checkCPUtype'
WARNING: vmlinux - Section mismatch: reference to .init.data:boot_params from .text between '_text' (at offset 0xc0100044) and 'checkCPUtype'
WARNING: vmlinux - Section mismatch: reference to .init.data:init_pg_tables_end from .text between '_text' (at offset 0xc01000a6) and 'checkCPUtype'
[...]
WARNING: vmlinux - Section mismatch: reference to .init.text:start_kernel from .paravirtprobe between '__start_paravirtprobe' (at offset 0xc03bc660) and '__stop_paravirtprobe'
WARNING: "_proxy_pda" [fs/nfsd/nfsd.ko] undefined!
WARNING: "_proxy_pda" [fs/lockd/lockd.ko] undefined!
WARNING: "_proxy_pda" [fs/fuse/fuse.ko] undefined!
WARNING: "_proxy_pda" [drivers/net/irda/toim3232-sir.ko] undefined!
WARNING: "_proxy_pda" [drivers/media/video/saa5249.ko] undefined!
make[1]: *** [__modpost] Error 1

I've heard that it now builds with gcc-4.2.0 snapshots. This is strange:
if the problem has been fixed for gcc-4.2.0, why doesn't it work for
gcc-4.1.2? arch/i386/kernel/vmlinux.lds.S does contain _proxy_pda = 0;

I'm not subscribed to the list.

-- 
   __("<         Marcin Kowalczyk
   \__/       qrczak@knm.org.pl
    ^^     http://qrnik.knm.org.pl/~qrczak/

