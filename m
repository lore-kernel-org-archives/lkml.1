Return-Path: <linux-kernel-owner+w=401wt.eu-S1759590AbXJLHpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbXJLHpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754148AbXJLHpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:45:17 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:38109 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbXJLHpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:45:15 -0400
Message-ID: <470F25E0.6020000@linux.vnet.ibm.com>
Date: Fri, 12 Oct 2007 13:14:32 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1 - build failure on axonram
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

The build fails with the following error message.

  CC      arch/powerpc/sysdev/axonram.o
arch/powerpc/sysdev/axonram.c:120:34: error: macro "bio_io_error" passed 2 arguments, but takes just 1
arch/powerpc/sysdev/axonram.c: In function ‘axon_ram_make_request’:
arch/powerpc/sysdev/axonram.c:120: error: ‘bio_io_error’ undeclared (first use in this function)
arch/powerpc/sysdev/axonram.c:120: error: (Each undeclared identifier is reported only once
arch/powerpc/sysdev/axonram.c:120: error: for each function it appears in.)
arch/powerpc/sysdev/axonram.c:134: error: too many arguments to function ‘bio_endio’
make[1]: *** [arch/powerpc/sysdev/axonram.o] Error 1
make: *** [arch/powerpc/sysdev] Error 2


The patch fixes the build failure.

Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---

--- linux-2.6.23/arch/powerpc/sysdev/axonram.c  2007-10-12 12:58:14.000000000 +0530
+++ linux-2.6.23/arch/powerpc/sysdev/~axonram.c 2007-10-12 12:51:43.000000000 +0530
@@ -117,7 +117,7 @@ axon_ram_make_request(struct request_que
        transfered = 0;
        bio_for_each_segment(vec, bio, idx) {
                if (unlikely(phys_mem + vec->bv_len > phys_end)) {
-                       bio_io_error(bio, bio->bi_size);
+                       bio_io_error(bio);
                        rc = -ERANGE;
                        break;
                }
@@ -131,7 +131,7 @@ axon_ram_make_request(struct request_que
                phys_mem += vec->bv_len;
                transfered += vec->bv_len;
        }
-       bio_endio(bio, transfered, 0);
+       bio_endio(bio, 0); 

        return rc;
 }


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

