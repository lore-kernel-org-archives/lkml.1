Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZEFGTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZEFGTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 02:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZEFGT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 02:19:28 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:45045 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZEFGT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 02:19:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=EmyTkIba9bBY45WKLjr6XkMuj+/vjJkZCiX979fZtWVEqMf5nuHzFH34m428mjyIpn
         /bcAopib33lz+E+7f37PtuIjiOMMHWNG7C+jZJJyLZYBbWbIACDYDrz7MRhXDG65jkgK
         xxMq8A7DDA0sVRuXE6Dw50eJ9qAQZKPc9A74Q=
Date: Wed, 6 May 2009 10:19:23 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Cc: LMMML <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mmotm] mm: setup_per_zone_inactive_ratio - fix comment and
	make it __init
Message-ID: <20090506061923.GA4865@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The caller of setup_per_zone_inactive_ratio is module_init function.
No need to keep the callee after is completed as well.
Also fix a comment.

CC: David Rientjes <rientjes@google.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

Index: linux-2.6.git/mm/page_alloc.c
=====================================================================
--- linux-2.6.git.orig/mm/page_alloc.c
+++ linux-2.6.git/mm/page_alloc.c
@@ -4540,8 +4540,6 @@ void setup_per_zone_pages_min(void)
 }
 
 /**
- * setup_per_zone_inactive_ratio - called when min_free_kbytes changes.
- *
  * The inactive anon list should be small enough that the VM never has to
  * do too much work, but large enough that each inactive page has a chance
  * to be referenced again before it is swapped out.
@@ -4562,7 +4560,7 @@ void setup_per_zone_pages_min(void)
  *    1TB     101        10GB
  *   10TB     320        32GB
  */
-static void setup_per_zone_inactive_ratio(void)
+static void __init setup_per_zone_inactive_ratio(void)
 {
 	struct zone *zone;
 
