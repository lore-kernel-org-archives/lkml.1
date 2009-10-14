Return-Path: <linux-kernel-owner+w=401wt.eu-S934052AbZJNW0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934052AbZJNW0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 18:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933082AbZJNW0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 18:26:49 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:35109 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932721AbZJNW0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 18:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CGIEMj9aFX5fzFNEKo6QbRwEGGzjAbFsROL199dVUj7r61t3XheBha9rcptlR+nkGi
         tg4h91u3VPdumqIINuy6H7KKxqOAzQfyNFnvWj9o1iovRpjEj8WT6xJlNWW+SAI0d4Of
         oMf2CokxThSPhqpnE++AYwEdbhgPeUAM11nVA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Roland Dreier <rdreier@cisco.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Bron Gondwana <brong@fastmail.fm>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Andrea Gelmini <andrea.gelmini@gmail.com>,
       "Trenton D. Adams" <trenton.d.adams@gmail.com>,
       Thomas Meyer <thomas@m3y3r.de>,
       Alessio Igor Bogani <abogani@texware.it>,
       Marcel Hilzinger <mhilzinger@linuxnewmedia.de>,
       Edward Shishkin <edward.shishkin@gmail.com>,
       Laurent Riffard <laurent.riffard@free.fr>
Subject: [PATCH 0/3] reiserfs/kill-bkl: Ioctl path fixes and unlocked_ioctl conversion
Date: Thu, 15 Oct 2009 00:26:04 +0200
Message-Id: <1255559167-5554-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This includes some fixes in the reiserfs ioctl path for the
reiserfs/kill-bkl tree.

As usual, any reviews or testings are very welcome.

Thanks,
Frederic.
---

The whole tree that drops the bkl from reiserfs 3 can be pulled from:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl

Frederic Weisbecker (3):
      kill-the-bkl/reiserfs: always lock the ioctl path
      kill-the-bkl/reiserfs: definitely drop the bkl from reiserfs_ioctl()
      kill-the-bkl/reiserfs: drop the fs race watchdog from _get_block_create_0()

 fs/reiserfs/dir.c           |    2 +-
 fs/reiserfs/file.c          |    2 +-
 fs/reiserfs/inode.c         |   11 +-----
 fs/reiserfs/ioctl.c         |   77 +++++++++++++++++++++++-------------------
 include/linux/reiserfs_fs.h |    3 +-
 5 files changed, 47 insertions(+), 48 deletions(-)
