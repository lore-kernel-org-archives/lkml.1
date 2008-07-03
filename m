Return-Path: <linux-kernel-owner+w=401wt.eu-S1757203AbYGCNjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203AbYGCNjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 09:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbYGCNi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 09:38:58 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:3414 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbYGCNiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 09:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=lIZsoZC9G8Z3+S7ZLnxrBLz8dUKGAU3qzyGKA30qio54/B2mgnHzy7/7c8PXAmJyfH
         K+5NOTMYx3S5sFN8b24R4aWtfyK4YIUG9XJ+uQEmIDM4EHYzSY2F3wbigthLCDt+mlBj
         NwvShWYT08E4lFa8zLOa+GHmdZCiK+vlyH0co=
Message-ID: <8bd0f97a0807030638g5eb8f0eavd740e990b1cdf1c5@mail.gmail.com>
Date: Thu, 3 Jul 2008 09:38:55 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>
Subject: linux-next: 1ea0704e (ptep_modify_prot transaction abstraction) breaks no-mmu
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the functions added to asm-generic/pgtable.h are only used by
mm/mprotect.c (a MMU-only file), but they were not added inside of the
CONFIG_MMU ifdef block.  since the functions rely on things inside of
CONFIG_MMU (the lines just above in pgtable.h), we get build failure
on all no-mmu setups:
  CC      init/main.o
In file included from include/asm/pgtable.h:94,
                 from include/linux/mm.h:39,
                 from include/asm/dma.h:39,
                 from include/linux/bootmem.h:8,
                 from init/main.c:27:
include/asm-generic/pgtable.h: In function '__ptep_modify_prot_start':
include/asm-generic/pgtable.h:210: error: implicit declaration of
function 'ptep_get_and_clear'
include/asm-generic/pgtable.h:210: error: incompatible types in return
make[1]: *** [init/main.o] Error 1
make: *** [init/main.o] Error 2
-mike
