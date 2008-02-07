Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYBGGSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYBGGSW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 01:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752901AbYBGGSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 01:18:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:54013 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYBGGSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:18:05 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 00/16] dlm patches for 2.6.25 (batch 2)
Date: Thu,  7 Feb 2008 00:09:03 -0600
Message-Id: <1202364559-9201-1-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a second batch of dlm patches that I think should be
ready for 2.6.25.  It's largely clean ups and minor fixes from
Al Viro, and a couple more added by me after Al pointed them out.
Thanks,
Dave

Al Viro (13):
      dlm: use proper C for dlm/requestqueue stuff (and fix alignment bug)
      dlm: dlm_process_incoming_buffer() fixes
      dlm: do not byteswap rcom_lock
      dlm: do not byteswap rcom_config
      dlm: use proper type for ->ls_recover_buf
      dlm: missing length check in check_config()
      dlm: validate data in dlm_recover_directory()
      dlm: verify that places expecting rcom_lock have packet long enough
      dlm: receive_rcom_lock_args() overflow check
      dlm: make find_rsb() fail gracefully when namelen is too large
      dlm: fix overflows when copying from ->m_extra to lvb
      dlm: fix dlm_dir_lookup() handling of too long names
      dlm: dlm/user.c input validation fixes

David Teigland (2):
      dlm: proper types for asts and basts
      dlm: eliminate astparam type casting

Denis Cheng (1):
      dlm: add __init and __exit marks to init and exit functions

 fs/dlm/ast.c          |    9 ++--
 fs/dlm/config.c       |    2 +-
 fs/dlm/debug_fs.c     |    8 +--
 fs/dlm/dir.c          |   28 +++++++++--
 fs/dlm/dlm_internal.h |   53 +++++++++++--------
 fs/dlm/lock.c         |  139 +++++++++++++++++++++++++++++--------------------
 fs/dlm/lock.h         |    2 +-
 fs/dlm/lockspace.c    |    2 +-
 fs/dlm/memory.c       |    4 +-
 fs/dlm/midcomms.c     |   33 +++++++-----
 fs/dlm/netlink.c      |    9 ++--
 fs/dlm/rcom.c         |   63 ++++++++++++++--------
 fs/dlm/recover.c      |    4 +-
 fs/dlm/requestqueue.c |   12 ++--
 fs/dlm/requestqueue.h |    2 +-
 fs/dlm/user.c         |   29 ++++------
 fs/dlm/util.c         |   61 ---------------------
 17 files changed, 235 insertions(+), 225 deletions(-)
