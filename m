Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbZIPQaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbZIPQaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbZIPQaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:30:09 -0400
Received: from sj-iport-3.cisco.com ([171.71.176.72]:31004 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759594AbZIPQaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:30:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGevsEqrR7PE/2dsb2JhbADHKohMAZBZBYQXglA
X-IronPort-AV: E=Sophos;i="4.44,398,1249257600"; 
   d="scan'208";a="190154466"
From: Roland Dreier <rdreier@cisco.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, jsquyres@cisco.com, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 16 Sep 2009 09:30:09 -0700
In-Reply-To: <aday6omhz9d.fsf@cisco.com> (Roland Dreier's message of "Thu, 10
	Sep 2009 21:38:22 -0700")
Message-ID: <ada1vm6g8dq.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 16 Sep 2009 16:30:09.0627 (UTC) FILETIME=[F5206AB0:01CA36EA]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry to hassle you about this, but I would like to know where things
stand.  I know (from the reflink discussion if nothing else) that you're
definitely not bashful about telling people when their code sucks, so
this silent treatment has me really flustered.  I've been showering and
brushing my teeth and everything, honest!

Seriously, this code solves a problem that the MPI/HPC people have been
complaining about for quite a while, and if possible I'd like to get
this upstream.  Or if you have a better idea, I'm all ears...

Thanks,
  Roland

 > Linus, please consider pulling from
 > 
 >     master.kernel.org:/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
 > 
 > This tree is also available from kernel.org mirrors at:
 > 
 >     git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband.git ummunotify
 > 
 > This will get "ummunotify," a new character device that allows a
 > userspace library to register for MMU notifications; this is
 > particularly useful for MPI implementions (message passing libraries
 > used in HPC) to be able to keep track of what wacky things consumers
 > do to their memory mappings.  My colleague Jeff Squyres from the Open
 > MPI project posted a blog entry about why MPI wants this:
 > 
 > http://blogs.cisco.com/ciscotalk/performance/comments/better_linux_memory_tracking/
 > 
 > His summary of ummunotify:
 > 
 >   "It’s elegant, doesn’t require strange linker tricks, and seems to
 >    work in all cases.  Yay!"
 > 
 > This code went through several review iterations on lkml and was in
 > -mm and -next for quite a few weeks.  Andrew is OK with merging it (I
 > think -- Andrew please correct me if I misunderstood you).
 > 
 > Roland Dreier (1):
 >       ummunotify: Userspace support for MMU notifications
 > 
 >  Documentation/Makefile                  |    3 +-
 >  Documentation/ummunotify/Makefile       |    7 +
 >  Documentation/ummunotify/ummunotify.txt |  150 ++++++++
 >  Documentation/ummunotify/umn-test.c     |  200 +++++++++++
 >  drivers/char/Kconfig                    |   12 +
 >  drivers/char/Makefile                   |    1 +
 >  drivers/char/ummunotify.c               |  566 +++++++++++++++++++++++++++++++
 >  include/linux/Kbuild                    |    1 +
 >  include/linux/ummunotify.h              |  121 +++++++
 >  9 files changed, 1060 insertions(+), 1 deletions(-)
 >  create mode 100644 Documentation/ummunotify/Makefile
 >  create mode 100644 Documentation/ummunotify/ummunotify.txt
 >  create mode 100644 Documentation/ummunotify/umn-test.c
 >  create mode 100644 drivers/char/ummunotify.c
 >  create mode 100644 include/linux/ummunotify.h
