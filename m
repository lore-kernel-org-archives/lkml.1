Return-Path: <linux-kernel-owner+w=401wt.eu-S1756058AbZEEGHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbZEEGHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753495AbZEEGHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:07:37 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:61755 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZEEGHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:07:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MmcEe4EL4PsxaFZJMuYV3wdF/eJ3ZnQ5Lvy7PZMM6lpTFQKTn0BJ71u0a9eHd71Q1i
         DXJagumdoNrJCWBxa2Bt3/3Afw68pzIvZpsU416argddw6tpHsZCVre9jYzy39HDcWbg
         ZpGQZq3GlCHtoFZgPCXqb6HWsg5rC6TEG7g08=
Date: Tue, 5 May 2009 10:07:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mmotm] mm: setup_per_zone_inactive_ratio - do not call for
	int_sqrt if not needed
Message-ID: <20090505060733.GA4494@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

int_sqrt returns 0 iif argument is zero so call it if only needed.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 mm/page_alloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.git/mm/page_alloc.c
=====================================================================
--- linux-2.6.git.orig/mm/page_alloc.c
+++ linux-2.6.git/mm/page_alloc.c
@@ -4553,8 +4553,9 @@ static void setup_per_zone_inactive_rati
 
 		/* Zone size in gigabytes */
 		gb = zone->present_pages >> (30 - PAGE_SHIFT);
-		ratio = int_sqrt(10 * gb);
-		if (!ratio)
+		if (gb)
+			ratio = int_sqrt(10 * gb);
+		else
 			ratio = 1;
 
 		zone->inactive_ratio = ratio;
