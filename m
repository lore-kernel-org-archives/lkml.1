Return-Path: <linux-kernel-owner+w=401wt.eu-S1752243AbZIGV1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbZIGV1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbZIGV1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:27:37 -0400
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:30608 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752027AbZIGV1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:27:36 -0400
X-Trace: 259185271/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.94.54/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.94.54
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroFAMQXpUpPRV42/2dsb2JhbACBU45jAchJhBgF
X-IronPort-AV: E=Sophos;i="4.44,348,1249254000"; 
   d="scan'208";a="259185271"
Date: Mon, 7 Sep 2009 22:26:51 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/8] mm: around get_user_pages flags
Message-ID: <Pine.LNX.4.64.0909072222070.15424@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a series of mm mods against current mmotm: mostly cleanup
of get_user_pages flags, but fixing munlock's OOM, sorting out the
"FOLL_ANON optimization", and reinstating ZERO_PAGE along the way.

 fs/binfmt_elf.c         |   42 ++------
 fs/binfmt_elf_fdpic.c   |   56 ++++-------
 include/linux/hugetlb.h |    4 
 include/linux/mm.h      |    4 
 mm/hugetlb.c            |   62 +++++++------
 mm/internal.h           |    7 -
 mm/memory.c             |  180 +++++++++++++++++++++++---------------
 mm/mlock.c              |   99 ++++++++------------
 mm/nommu.c              |   22 ++--
 9 files changed, 235 insertions(+), 241 deletions(-)

Hugh
