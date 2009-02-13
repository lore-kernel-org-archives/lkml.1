Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZBMAQY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZBMAQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 19:16:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZBMAQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 19:16:16 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:52293 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZBMAQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 19:16:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=bKO3FIzZP7IEtQxBVVAI2JgyDuqwz2XwVGlOCsAN+dhk/NY3MWAKnFnOPvMqY7PeEw
         e72nGtMOi6fBRumB+/h3q7r3VS7sxJmucFXby+5ZVGxCu+Bktv12DZ1xZGd4K2YXIPwQ
         qZtM0WB7pTe1vCw8D6dFNevoxvAMUKCp63UZA=
Date: Fri, 13 Feb 2009 09:15:39 +0900
From: MinChan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       MinChan Kim <minchan.kim@gmail.com>
Subject: [patch 0/2 v2] vmscan: one cleanup, one bugfix
Message-Id: <20090213091539.e26e5e8e.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Andrew,

the first patch is that it moves the suspend-to-disk memory
shrinking functions to use sc.nr_reclaimed all over instead of maintaining
an extra local variable. It was suggested by Kosaki-san and modified 
by me and Hannes. 

The second patch which is written by Hannes is a bugfix 
for shrink_all_memory() which currently does reclaim more than requested 
because of setting swap_cluster_max once to our overall reclaim goal 
but failing to decrease it while we go and reclaim is making progress.  
Hannes added Nigel Cunningham to Cc because ISTR he complained
about exactly this behaviour.  Well, this patch seems to fix it, Hannes even
added some shiny numbers coming from real tests!

I just remaked second patch based on my first patch.
Notice that it is just Hannes's contribution. :)

-- 
Kinds Regards
MinChan Kim
