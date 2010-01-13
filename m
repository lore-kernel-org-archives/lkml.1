Return-Path: <linux-kernel-owner+w=401wt.eu-S1755784Ab0AMPeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755784Ab0AMPeV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:34:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755579Ab0AMPeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:34:20 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:54998 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab0AMPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:34:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition:x-operating-system
         :user-agent;
        b=jmjZIi4DE/6znvqcOHkSRECAlGcod0/2AoJ/g2P2U12w2dBy7ikdpBW4AyZ+42k5M/
         r4G4AoJd5d/ikgeGSAo3orJPUdWMygwmtjmj578LOXCtyW8VXm5KsNKIUacoUp2bSZZS
         gDJFtRPnGb2TY/Rxxi58FCeazmkotUHCmqGcM=
Date: Wed, 13 Jan 2010 23:34:12 +0800
From: Li Hong <lihong.hi@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 2/3] mm: page_alloc.c Adjust a call site to
 trace_mm_page_free_direct
Message-ID: <20100113153412.GA12398@xhl>
Reply-To: 20100113144917.GA11934@xhl
Mail-Followup-To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux xhl 2.6.31-14-generic
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a call of 'trace_mm_page_free_direct' from 'free_hot_page' to
'free_hot_cold_page'. It is clearer and close to 'kmemcheck_free_shadow', as it
is done in function '__free_pages_ok'.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 24344cd..175dd36 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1082,6 +1082,7 @@ static void free_hot_cold_page(struct page *page, int cold)
        int migratetype;
        int wasMlocked = __TestClearPageMlocked(page);
 
+       trace_mm_page_free_direct(page, 0);
        kmemcheck_free_shadow(page, 0);
 
        if (PageAnon(page))
@@ -1136,7 +1137,6 @@ out:
 
 void free_hot_page(struct page *page)
 {
-       trace_mm_page_free_direct(page, 0);
        free_hot_cold_page(page, 0);
 }
        
-- 
1.6.3.3

