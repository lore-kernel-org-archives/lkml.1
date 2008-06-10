Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbYFJVlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbYFJVlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758702AbYFJVku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:40:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:9790 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757590AbYFJVku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:40:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BYGDwxjk6h0vMGoPsuwlqgdj6+DTJDDgnF4V8x9UNi3gIk23aBtV+7kds9oirjSHoL
         eSn4ZBue5BaYynxoit2pOWhBtcWm1OzO4A2K/9LoLF+XIJLeg/KU+4iG0VxoBQA/f5hG
         zn1MPiTdAIshEp2Sh1ZarUDMXXXVl0Cl9OWzI=
Message-ID: <524f69650806101440j70c695a7rd5be464b7075e6cf@mail.gmail.com>
Date: Tue, 10 Jun 2008 16:40:43 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: problem with kthread changes that went into cifs_demultiplex_thread
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080610132400.4283b36d@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650806100841r4f90bd0k342c3264c8c64362@mail.gmail.com>
	 <20080610132400.4283b36d@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK - have added the patch for the negotiate problem (waiting on
kthread_stop) and the fix from Marcin for the oops when mount helper
missing and DFS enabled and no mount data.   The only other fixes in
cifs-2.6.git now are:

The following changes since commit cbff290491cd97bcd449b14f672d98992ddad5cb:
  Linus Torvalds (1):
        Merge branch 'merge' of git://git.kernel.org/.../paulus/powerpc

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
..BRANCH.NOT.VERIFIED..

Jeff Layton (4):
      on non-posix shares, clear write bits in mode when ATTR_READONLY is set
      when creating new inodes, use file_mode/dir_mode exclusively on
mount without unix extensions
      silently ignore ownership changes unless unix extensions are
enabled or we're faking uid changes
      disable most mode changes on non-unix/non-cifsacl mounts

Steve French (6):
      [CIFS] remove unused variables
      [CIFS] remove trailing whitespace
      [CIFS] warn if both dynperm and cifsacl mount options specified
      [CIFS] Correct incorrect obscure open flag
      [CIFS] Fix hang in mount when negprot causes server to kill tcp session
      [CIFS] cifs: fix oops on mount when CONFIG_CIFS_DFS_UPCALL is enabled

 fs/cifs/CHANGES    |    5 ++
 fs/cifs/cifsfs.c   |   21 ++++----
 fs/cifs/cifsglob.h |    3 +-
 fs/cifs/cifspdu.h  |   23 ++++++--
 fs/cifs/cifssmb.c  |    6 +--
 fs/cifs/connect.c  |    5 ++
 fs/cifs/dir.c      |    4 +-
 fs/cifs/file.c     |    7 ---
 fs/cifs/inode.c    |  148 ++++++++++++++++++++++++++++++---------------------
 fs/cifs/misc.c     |    3 +-
 fs/cifs/readdir.c  |   77 ++++++++++++++-------------
 11 files changed, 172 insertions(+), 130 deletions(-)

I will request a merge to mainline from cifs-2.6.git when you have had
a chance to look at them and double check (since I want to make sure
that you still want this subset of the dynperm changes)

-- 
Thanks,

Steve
