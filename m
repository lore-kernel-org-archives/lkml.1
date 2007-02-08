Return-Path: <linux-kernel-owner+w=401wt.eu-S1750871AbXBHSaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750871AbXBHSaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:30:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbXBHSaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:30:22 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:19490 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbXBHSaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:30:21 -0500
Date: Thu, 8 Feb 2007 10:30:08 -0800
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com, joel.becker@oracle.com
Subject: [git patches] ocfs2 and configfs updates
Message-ID: <20070208183008.GV14799@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Included in this patchset is:

* A rather involved series of ocfs2 dlm fixes - these were too large (and
  tested too late) to really go into 2.6.20. Mostly this revolves around
  lock migration race fixes. Most forms of migration had been temporarily
  disabled in the ocfs2 dlm due to those problems, but with these patches it
  works great again.

* Some cleanups in heartbeat code, and our section of fs/Kconfig.

* A small configfs fix from Joel.

So nothing major in the feature area for now, just some more bugfixes and
cleanups.
	--Mark

Please pull from 'upstream-linus' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2.git upstream-linus

to receive the following updates:

 fs/Kconfig                      |    1 
 fs/configfs/file.c              |    9 
 fs/ocfs2/cluster/heartbeat.c    |  158 ++--------
 fs/ocfs2/cluster/tcp.c          |   35 +-
 fs/ocfs2/cluster/tcp.h          |    6 
 fs/ocfs2/cluster/tcp_internal.h |   12 
 fs/ocfs2/dlm/dlmast.c           |   14 
 fs/ocfs2/dlm/dlmcommon.h        |  130 +++++++-
 fs/ocfs2/dlm/dlmconvert.c       |   40 --
 fs/ocfs2/dlm/dlmdebug.c         |   30 +-
 fs/ocfs2/dlm/dlmdomain.c        |  253 +++++++++++++----
 fs/ocfs2/dlm/dlmlock.c          |    7 
 fs/ocfs2/dlm/dlmmaster.c        |  579 +++++++++++++++++++++++++++++++++++-----
 fs/ocfs2/dlm/dlmrecovery.c      |  182 ++++++++++--
 fs/ocfs2/dlm/dlmthread.c        |  200 ++++++-------
 fs/ocfs2/dlm/dlmunlock.c        |   15 -
 fs/ocfs2/vote.c                 |    8 
 17 files changed, 1211 insertions(+), 468 deletions(-)

Adrian Bunk:
      fs/ocfs2/dlm/: make functions static

Joel Becker:
      configfs: Zero terminate data in configfs attribute writes.

Kurt Hackel:
      ocfs2_dlm: fix cluster-wide refcounting of lock resources
      ocfs2_dlm: Fixes race between migrate and dirty
      ocfs2_dlm: Make dlmunlock() wait for migration to complete
      ocfs2_dlm: Fix migrate lockres handler queue scanning
      ocfs2_dlm: Flush dlm workqueue before starting to migrate
      ocfs2_dlm: Drop inflight refmap even if no locks found on the lockres
      ocfs2_dlm: Dlm dispatch was stopping too early
      ocfs2_dlm: wake up sleepers on the lockres waitqueue
      ocfs2_dlm: Silence a failed convert
      ocfs2_dlm: Cookies in locks not being printed correctly in error messages
      ocfs2: Added post handler callable function in o2net message handler
      ocfs2_dlm: Calling post handler function in assert master handler

Philipp Reisner:
      ocfs2 heartbeat: clean up bio submission code

Randy Dunlap:
      ocfs2: drop INET from Kconfig, not needed

Srinivas Eeda:
      ocfs2_dlm: disallow a domain join if node maps mismatch

Sunil Mushran:
      ocfs2: Binds listener to the configured ip address
      ocfs2_dlm: Ensure correct ordering of set/clear refmap bit on lockres
      ocfs2_dlm: Silence some messages during join domain
      ocfs2_dlm: Add timeout to dlm join domain

Zhen Wei:
      ocfs2: introduce sc->sc_send_lock to protect outbound outbound messages

Thanks,
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
