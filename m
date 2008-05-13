Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbYEMUHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbYEMUHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYEMUHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:07:43 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:44885 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985AbYEMUHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:07:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=NGMTDV97aENGmX92R5ZMTK/wvPGXOWLAnG/zS6joQJbpnJX/1jJylsJeZeepcC0F5kf2rLUz3WxNPLuJTxyq1oJuU3mcYwOLPmN2n5ypPZik2XBYaa/maIfo3nRS1s37R/qDFyXVgm3fbf6Jmzl1t4V+lyacwydC2RrKTRMVT5g=
Date: Tue, 13 May 2008 22:07:36 +0200
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kallsyms: fix potential overflow in binary search
Message-ID: <20080513200736.GA17909@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 61b840f071e496f632fcc293f5435428cfc98844 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Tue, 13 May 2008 10:20:27 +0200
Subject: [PATCH] kallsyms: fix potential overflow in binary search

This will probably never trigger... but it won't hurt to be careful.

http://googleresearch.blogspot.com/2006/06/extra-extra-read-all-about-it-nearly.html

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 kernel/kallsyms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 6fc0040..38fc10a 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -176,7 +176,7 @@ static unsigned long get_symbol_pos(unsigned long addr,
 	high = kallsyms_num_syms;
 
 	while (high - low > 1) {
-		mid = (low + high) / 2;
+		mid = low + (high - low) / 2;
 		if (kallsyms_addresses[mid] <= addr)
 			low = mid;
 		else
-- 
1.5.4.1

