Return-Path: <linux-kernel-owner+w=401wt.eu-S1753792AbYJ2J5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792AbYJ2J5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:57:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYJ2J4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:56:55 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59867 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYJ2J4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:56:54 -0400
Message-ID: <49083361.5060907@gentoo.org>
Date: Wed, 29 Oct 2008 10:56:49 +0100
From: =?ISO-8859-1?Q?Ra=FAl_Porcel?= <armin76@gentoo.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
CC: klausman@gentoo.org
Subject: [ALPHA] 2.6.28-rc fails to compile
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I guess the git bisect says everything, but if you need more info,
please say so.

  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/basic/docproc
  HOSTCC  scripts/basic/hash
  CC      kernel/bounds.s
  GEN     include/linux/bounds.h
  CC      arch/alpha/kernel/asm-offsets.s
In file included from
/usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/core_tsun
ami.h:5,
                 from
/usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h:232,
                 from arch/alpha/kernel/asm-offsets.c:12:
include/linux/pci.h: In function 'pci_ioremap_bar':
include/linux/pci.h:1148: error: implicit declaration of function
'ioremap_nocac
he'
include/linux/pci.h:1149: warning: return makes pointer from integer
without a c
ast
In file included from arch/alpha/kernel/asm-offsets.c:12:
/usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h: At top level:
/usr/src/linux-2.6.28-rc2/arch/alpha/include/asm/io.h:300: error:
conflicting ty
pes for 'ioremap_nocache'
include/linux/pci.h:1148: error: previous implicit declaration of
'ioremap_nocac
he' was here
make[1]: *** [arch/alpha/kernel/asm-offsets.s] Error 1
make: *** [prepare0] Error 2


-------------------------

aa42d7c6138afdc54f74e971456a0fbfec16b77b is first bad commit
commit aa42d7c6138afdc54f74e971456a0fbfec16b77b
Author: Arjan van de Ven <arjan@infradead.org>
Date:   Sun Sep 28 16:36:11 2008 -0700

    PCI: introduce an pci_ioremap(pdev, barnr) function
