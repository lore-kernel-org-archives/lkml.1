Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZLPDDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZLPDDZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZLPDDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:03:24 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51995 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZLPDDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:03:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 16 Dec 2009 12:00:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>, andi@firstfloor.org,
       minchan.kim@gmail.com
Subject: [mm][RFC][PATCH 0/11] mm accessor updates.
Message-Id: <20091216120011.3eecfe79.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is from Christoph Lameter's mm_accessor patch posted 5/Nov.

Replacing all access to mm->mmap_sem with mm-accessor functions as
 mm_read_lock,
 mm_write_lock,
 etc...

This kind of function allows us to improve page fault performance etc..
For example, skil down_read(mmap_sem) in some situation.
(as: http://marc.info/?l=linux-mm&m=125809791306459&w=2)

Because I like this idea, I updated his patch. But the size of patch is
very big and mmap_sem is used in many place, some senario for merging
will be required. Spliting into small pieace and go ahead in step by step.

My plan is...
  1. leave  mm->mmap_sem as it is for a while.
  2. replace all mmap_sem access under /kernel /mm /fs etc..
  3. replace all mmap_sem callers under /driver
  4. And finally, post per-arch patches.

Now this set is organized as
 [1/11] mm_accessor definition
 [2/11] a patch for kernel, mm
 [3/11] a patch for fs (procfs and codes around get_user_page())
 [4/11] a patch for kvm
 [5/11] a patch for tomoyo
 [6/11] a patch for driver/gpu
 [7/11] a patch for infiniband
 [8/11] a patch for driver/media/video
 [9/11] a patch for sgi gru
 [10/11] a patch for misc drivers
 [11/11] a patch for x86.

I think, once I push [1/11] (and 2/11]), I can update other calls in each tree.
And finally successfully rename mm->mmap_sem to some other name.

Any comment is welcome.

Thanks,
-Kame

