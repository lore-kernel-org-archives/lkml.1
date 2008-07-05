Return-Path: <linux-kernel-owner+w=401wt.eu-S1752959AbYGELKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959AbYGELKa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:10:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYGELKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:10:22 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:26876 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbYGELKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:10:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LqwsD6mE0B/ifLNh888z1EHorsgB/NxT6hztpauO7e4+cFwwMgbPWLNgWoLEijGNSh
         8s+60AAsv0mtpuqY2Jdt0qEWf2MeVdwvETEYpHs+PO1RT2kHuvQlHQIr4Qzk3PIjWciJ
         L/yvFBba6D0rsYnw/F2spgbpw9DiFm9TEtiwA=
Date: Sat, 5 Jul 2008 20:10:10 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 1/2] swsusp: simplify memory_bm_find_bit()
Message-ID: <20080705110946.GA17071@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit obtained by the function memory_bm_find_bit() is represented
by addr and bit_nr. The callers of memory_bm_find_bit() just use addr
and bit_nr as the arguments of set_bit/clear_bit/test_bit.

This patch simplifies the representation of the obtained bit without
using BM_BITS_PER_CHUNK.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org
---
 kernel/power/snapshot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: 2.6-git/kernel/power/snapshot.c
===================================================================
--- 2.6-git.orig/kernel/power/snapshot.c
+++ 2.6-git/kernel/power/snapshot.c
@@ -478,8 +478,8 @@ static int memory_bm_find_bit(struct mem
 	}
 	zone_bm->cur_block = bb;
 	pfn -= bb->start_pfn;
-	*bit_nr = pfn % BM_BITS_PER_CHUNK;
-	*addr = bb->data + pfn / BM_BITS_PER_CHUNK;
+	*bit_nr = pfn;
+	*addr = bb->data;
 	return 0;
 }
 
