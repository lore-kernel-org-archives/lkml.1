Return-Path: <linux-kernel-owner+w=401wt.eu-S1759961AbYA3Uhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961AbYA3Uhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 15:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbYA3Uhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 15:37:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbYA3Uhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:37:35 -0500
Date: Wed, 30 Jan 2008 14:29:14 -0600
From: David Teigland <teigland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] dlm updates for 2.6.25
Message-ID: <20080130202914.GA21643@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull dlm updates for 2.6.25 from:

  git://git.kernel.org/pub/scm/linux/kernel/git/teigland/dlm.git for-linus

In the past, the dlm patches went through the gfs2 git tree.  We've moved
to a separate tree because the dlm work is now largely independent from
gfs2, and dlm patches are mostly relevant for other applications.

There are no new features, only fixes for various bugs or problems.  They
stem mainly from mixed architecture testing, and new tests that overlap
recovery with userland stress tests.

Thanks,
Dave


Adrian Bunk (1):
      dlm: proper prototypes

David Teigland (14):
      dlm: don't print common non-errors
      dlm: use dlm prefix on alloc and free functions
      dlm: use fixed errno values in messages
      dlm: clear ast_type when removing from astqueue
      dlm: recover locks waiting for overlap replies
      dlm: another call to confirm_master in receive_request_reply
      dlm: reject messages from non-members
      dlm: validate messages before processing
      dlm: reject normal unlock when lock is waiting for lookup
      dlm: limit dir lookup loop
      dlm: fix possible use-after-free
      dlm: change error message to debug
      dlm: keep cached master rsbs during recovery
      dlm: clean ups

Denis Cheng (1):
      dlm: static initialization improvements

Fabio M. Di Nitto (2):
      dlm: align midcomms message buffer
      dlm: swap bytes for rcom lock reply

Lon Hohberger (1):
      dlm: bind connections from known local address when using TCP

Patrick Caulfeld (2):
      dlm: close othercons
      dlm: Sanity check namelen before copying it

 fs/dlm/dir.c          |   76 +++++++--------
 fs/dlm/dlm_internal.h |   16 +++
 fs/dlm/lock.c         |  249 +++++++++++++++++++++++++++++++++++--------------
 fs/dlm/lock.h         |    2 -
 fs/dlm/lockspace.c    |   16 +---
 fs/dlm/lowcomms.c     |   15 +++-
 fs/dlm/main.c         |   10 --
 fs/dlm/member.c       |    4 +-
 fs/dlm/member.h       |    3 +-
 fs/dlm/memory.c       |   32 ++-----
 fs/dlm/memory.h       |   16 ++--
 fs/dlm/midcomms.c     |   15 ++-
 fs/dlm/rcom.c         |   25 +----
 fs/dlm/recover.c      |   27 +++++-
 fs/dlm/recoverd.c     |   11 +-
 fs/dlm/user.c         |   29 ++++--
 fs/dlm/util.c         |   82 +++++++++++++---
 17 files changed, 395 insertions(+), 233 deletions(-)

