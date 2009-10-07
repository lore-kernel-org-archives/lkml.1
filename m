Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbZJGKmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbZJGKmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758778AbZJGKmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:42:04 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:47613 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757432AbZJGKmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:42:03 -0400
Date: Wed, 7 Oct 2009 12:41:25 +0200
From: Andreas Mohr <andi@lisas.de>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Adam Belay <abelay@novell.com>,
       linux-acpi@vger.kernel.org
Subject: 2.6.32-rc3: floating-point build failure (undefined reference to
	`__udivdi3' in menu governor)
Message-ID: <20091007104125.GA1449@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

didn't find any report about this, so...

  LD      .tmp_vmlinux1
drivers/built-in.o(.text+0xd85a1): In function `menu_select':
drivers/cpuidle/governors/menu.c:212: undefined reference to `__udivdi3'
make: *** [.tmp_vmlinux1] Error 1


The symbol being __udivdi3 sounds to me like it's illegal FP use here.

This is not necessarily a -rc3 regression, though (currently running
2.6.29-rc7 on this box).


# gcc -v
Reading specs from /usr/lib/gcc-lib/i386-redhat-linux/3.2.3/specs
Configured with: ../configure --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --enable-shared --enable-threads=posix --disable-checking --with-system-zlib --enable-__cxa_atexit --host=i386-redhat-linux
Thread model: posix
gcc version 3.2.3 20030502 (Red Hat Linux 3.2.3-49)

(yes, I know... ;)

Andreas Mohr
