Return-Path: <linux-kernel-owner+w=401wt.eu-S1759490AbZDOIgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759490AbZDOIgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759338AbZDOIgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:36:06 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:52854 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758354AbZDOIgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:36:02 -0400
Date: Wed, 15 Apr 2009 10:35:57 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: Next April 15: s390 allnoconfig build failure
Message-ID: <20090415103557.0b313e35@osiris.boeblingen.de.ibm.com>
In-Reply-To: <49E58211.6040900@in.ibm.com>
References: <20090415144745.c4fb5c4b.sfr@canb.auug.org.au>
	<49E58211.6040900@in.ibm.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Apr 2009 12:13:29 +0530
Sachin Sant <sachinp@in.ibm.com> wrote:

> Today's next tree build (s390 allnoconfig) failed with
> 
> arch/s390/kernel/ipl.c: In function 'stop_run':
> arch/s390/kernel/ipl.c:1461: error: implicit declaration of function 
> 'signal_processor'
> arch/s390/kernel/ipl.c:1461: error: 'sigp_stop' undeclared (first use in 
> this function)
> arch/s390/kernel/ipl.c:1461: error: (Each undeclared identifier is 
> reported only once
> arch/s390/kernel/ipl.c:1461: error: for each function it appears in.)
> make[1]: *** [arch/s390/kernel/ipl.o] Error 1

Patch below will fix it. Thanks for reporting.

Subject: [PATCH] ipl: fix compile breakage

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix this for !CONFIG_SMP:

arch/s390/kernel/ipl.c: In function 'stop_run':
arch/s390/kernel/ipl.c:1461: error: implicit declaration of function 'signal_processor'

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

diff -u -r1.67 -r1.68 linux-2.5/arch/s390/kernel/ipl.c
--- linux-2.5/arch/s390/kernel/ipl.c	24 Mar 2009 11:33:16 -0000	1.67
+++ linux-2.5/arch/s390/kernel/ipl.c	15 Apr 2009 08:33:38 -0000	1.68
@@ -23,6 +23,7 @@
 #include <asm/ebcdic.h>
 #include <asm/reset.h>
 #include <asm/sclp.h>
+#include <asm/sigp.h>
 #include <asm/checksum.h>

 #define IPL_PARM_BLOCK_VERSION 0
