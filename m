Return-Path: <linux-kernel-owner+w=401wt.eu-S933496AbZKXQh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbZKXQh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:37:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbZKXQh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:37:58 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:26840 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933342AbZKXQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:37:57 -0500
X-Trace: 295540424/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.56.48/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.56.48
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBAP2aC0tPRTgw/2dsb2JhbAAIkD4BxXCEOQSDGQ
X-IronPort-AV: E=Sophos;i="4.47,280,1257120000"; 
   d="scan'208";a="295540424"
Date: Tue, 24 Nov 2009 16:37:42 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Chris Wright <chrisw@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 0/9] ksm: swapping
Message-ID: <Pine.LNX.4.64.0911241634170.24427@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a series of nine patches against 2.6.32-rc7-mm1, at last making
KSM's shared pages swappable.  The main patches, 2 3 and 4, have been
around for over a month; but I underestimated the tail of the job,
working out the right compromises to deal with the consequences of
having ksm pages on the LRUs.

 Documentation/vm/ksm.txt |   22 -
 include/linux/ksm.h      |   71 ++++
 include/linux/migrate.h  |    8 
 include/linux/rmap.h     |   35 ++
 mm/Kconfig               |    2 
 mm/internal.h            |    3 
 mm/ksm.c                 |  567 ++++++++++++++++++++++++++++---------
 mm/memcontrol.c          |    7 
 mm/memory.c              |    6 
 mm/memory_hotplug.c      |    2 
 mm/mempolicy.c           |   19 -
 mm/migrate.c             |  112 ++-----
 mm/mlock.c               |    4 
 mm/rmap.c                |  151 +++++++--
 mm/swapfile.c            |   11 
 15 files changed, 741 insertions(+), 279 deletions(-)

Thanks!
Hugh
