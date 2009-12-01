Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbZLAQ07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbZLAQ07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbZLAQ06
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:26:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbZLAQ06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:26:58 -0500
Date: Tue, 1 Dec 2009 08:24:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       steved@redhat.com, jens.axboe@oracle.com, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] SLOW_WORK: Move slow_work's proc file to debugfs
In-Reply-To: <20091201161455.GB24897@elte.hu>
Message-ID: <alpine.LFD.2.00.0912010821170.2872@localhost.localdomain>
References: <6941.1259681771@redhat.com> <20091201161455.GB24897@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Dec 2009, Ingo Molnar wrote:
> 
> Nice - thanks for doing this so quickly! It might sound like nitpicking 
> but /proc ABIs tend to be a lot harder to get rid of than debugfs 
> interfaces.

Ok, I applied it, so we'll not switch interfaces (even if they are just 
for debugging) across releases.

Btw David, for things like this, it's _really_ nice to use git rename 
detection. The diffstat (w/ summary) with rename detection looks like 
this:

 Documentation/slow-work.txt                      |    4 ++--
 include/linux/slow-work.h                        |    8 ++++----
 init/Kconfig                                     |    8 ++++----
 kernel/Makefile                                  |    2 +-
 kernel/{slow-work-proc.c => slow-work-debugfs.c} |    4 ++--
 kernel/slow-work.c                               |   18 ++++++++++++------
 kernel/slow-work.h                               |    6 +++---
 7 files changed, 28 insertions(+), 22 deletions(-)
 rename kernel/{slow-work-proc.c => slow-work-debugfs.c} (97%)

which makes it obvious that the changes were really just about renaming. 
Compare to the non-rename-aware one:

 Documentation/slow-work.txt |    4 +-
 include/linux/slow-work.h   |    8 +-
 init/Kconfig                |    8 +-
 kernel/Makefile             |    2 +-
 kernel/slow-work-debugfs.c  |  227 +++++++++++++++++++++++++++++++++++++++++++
 kernel/slow-work-proc.c     |  227 -------------------------------------------
 kernel/slow-work.c          |   18 +++-
 kernel/slow-work.h          |    6 +-
 8 files changed, 253 insertions(+), 247 deletions(-)
 create mode 100644 kernel/slow-work-debugfs.c
 delete mode 100644 kernel/slow-work-proc.c

where you can kind of guess that slow-work-[proc|debugfs].c are largely 
the same, but you don't actually _see_ that it only has four lines of 
changes (and the patch then shows that the changes are just to comments).

			Linus
