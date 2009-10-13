Return-Path: <linux-kernel-owner+w=401wt.eu-S1759311AbZJMKHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759311AbZJMKHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 06:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZJMKHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 06:07:30 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:56970 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062AbZJMKH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 06:07:28 -0400
Date: Tue, 13 Oct 2009 15:36:48 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: schwidefsky@de.ibm.com
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, heiko.carstens@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: [BUILD-FAILURE] next-20091013 - s390x build breaks at mm/fault
	with !CONFIG_S390_EXEC_PROTECT
Message-ID: <20091013100648.GA7542@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20091013162312.8b93998b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091013162312.8b93998b.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin,

	next-20091013 randconfig build breaks on s390, with
CONFIG_S390_EXEC_PROTECT=y

arch/s390/mm/fault.c: In function 'signal_return':
arch/s390/mm/fault.c:221: error: implicit declaration of function 'is_compat_task'
make[1]: *** [arch/s390/mm/fault.o] Error 1

is_compat_task is defined at asm/compat.h, including the 
header, helps

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
--
 arch/s390/mm/fault.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 43b3778..4e73e8b 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -34,6 +34,7 @@
 #include <asm/pgtable.h>
 #include <asm/s390_ext.h>
 #include <asm/mmu_context.h>
+#include <asm/compat.h>
 #include "../kernel/entry.h"
 
 #ifndef CONFIG_64BIT

			
			Kamalesh
