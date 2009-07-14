Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbZGNJIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbZGNJIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753804AbZGNJIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:08:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60850 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbZGNJIV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:08:21 -0400
Message-ID: <4A5C4B16.1080709@cn.fujitsu.com>
Date: Tue, 14 Jul 2009 17:08:38 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Maxim Shchetynin <maxim@de.ibm.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Remove unused variable in axon_ram_make_request()
References: <4A5C499A.8080408@cn.fujitsu.com>
In-Reply-To: <4A5C499A.8080408@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable named "transfered" is not used in this function,
we should remove it.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/powerpc/sysdev/axonram.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index a477991..29a8bbf 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -111,13 +111,11 @@ axon_ram_make_request(struct request_queue *queue, 
struct bio *bio)
     unsigned long phys_mem, phys_end;
     void *user_mem;
     struct bio_vec *vec;
-    unsigned int transfered;
     unsigned short idx;
     int rc = 0;
 
     phys_mem = bank->io_addr + (bio->bi_sector << AXON_RAM_SECTOR_SHIFT);
     phys_end = bank->io_addr + bank->size;
-    transfered = 0;
     bio_for_each_segment(vec, bio, idx) {
         if (unlikely(phys_mem + vec->bv_len > phys_end)) {
             bio_io_error(bio);
@@ -132,7 +130,6 @@ axon_ram_make_request(struct request_queue *queue, 
struct bio *bio)
             memcpy((void *) phys_mem, user_mem, vec->bv_len);
 
         phys_mem += vec->bv_len;
-        transfered += vec->bv_len;
     }
     bio_endio(bio, 0);
 
-- 
1.5.5.3


