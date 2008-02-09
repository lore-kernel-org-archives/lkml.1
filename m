Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYBIPZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYBIPZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYBIPZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:25:34 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:39644 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbYBIPZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=IwG//UJp0PZTYoainnefYnUp/OQLJgO1KVGZcRAe/Ze90A/RbvLZwhS0ew6A7tlZRMJFNUAngfBmZ8Ei6hGwz72ghThxh/pIrUoO5KVbST90CVwlaNsugvQJE3ZGBe3w04BUF5KJt2jcyQ7tfqB1+rEDTeKnaBl0TYqARd8coQ8=
Message-ID: <2f11576a0802090725w6437bcc5vde2392c794095f6b@mail.gmail.com>
Date: Sun, 10 Feb 2008 00:25:31 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8][for -mm] mem_notify v6: add new mem_notify field to /proc/zoneinfo
Cc: kosaki.motohiro@jp.fujitsu.com, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-fsdevel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Jon Masters" <jonathan@jonmasters.org>, "Zan Lynx" <zlynx@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 23cfcf84ff713034
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

show new member of zone struct by /proc/zoneinfo.

ChangeLog:
	v5: change display order to at last.


Signed-off-by: Marcelo Tosatti <marcelo@kvack.org>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 mm/vmstat.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: b/mm/vmstat.c
===================================================================
--- a/mm/vmstat.c	2008-01-23 22:06:05.000000000 +0900
+++ b/mm/vmstat.c	2008-01-23 22:08:00.000000000 +0900
@@ -795,10 +795,12 @@ static void zoneinfo_show_print(struct s
 	seq_printf(m,
 		   "\n  all_unreclaimable: %u"
 		   "\n  prev_priority:     %i"
-		   "\n  start_pfn:         %lu",
-			   zone_is_all_unreclaimable(zone),
+		   "\n  start_pfn:         %lu"
+		   "\n  mem_notify_status: %i",
+		   zone_is_all_unreclaimable(zone),
 		   zone->prev_priority,
-		   zone->zone_start_pfn);
+		   zone->zone_start_pfn,
+		   zone->mem_notify_status);
 	seq_putc(m, '\n');
 }
