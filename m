Return-Path: <linux-kernel-owner+w=401wt.eu-S1758450AbYAXQ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450AbYAXQ66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 11:58:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758252AbYAXQ6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 11:58:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758241AbYAXQ6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 11:58:34 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/19] dlm patches for 2.6.25
Date: Thu, 24 Jan 2008 10:50:23 -0600
Message-Id: <1201193442-8260-1-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These are the dlm patches I'd like to see in 2.6.25.  There are no new
features, only fixes for various bugs or problems.  They stem mainly from
mixed architecture testing, and new tests that overlap recovery with
userland stress tests.  Dave

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
 fs/dlm/midcomms.c     |    2 +-
 fs/dlm/recover.c      |   27 +++++-
 fs/dlm/recoverd.c     |   11 +-
 fs/dlm/user.c         |   16 ++-
 fs/dlm/util.c         |   66 ++++++++++++-
 16 files changed, 370 insertions(+), 191 deletions(-)

Adrian Bunk (1):
      dlm: proper prototypes

David Teigland (13):
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

Fabio M. Di Nitto (2):
      dlm: align midcomms message buffer
      dlm: swap bytes for rcom lock reply

Lon Hohberger (1):
      dlm: bind connections from known local address when using TCP

Patrick Caulfeld (2):
      dlm: close othercons
      dlm: Sanity check namelen before copying it

