Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZCZRyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZCZRyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756333AbZCZRx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:53:59 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60586 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZCZRx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:53:59 -0400
Date: Thu, 26 Mar 2009 17:53:14 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
       Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: [PATCH 2/2] Make relatime default
Message-ID: <20090326175314.GC7198@srcf.ucam.org>
References: <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326144707.GA6239@mit.edu> <alpine.LFD.2.00.0903260914440.3032@localhost.localdomain> <20090326170714.GF6239@mit.edu> <alpine.LFD.2.00.0903261015050.3032@localhost.localdomain> <20090326174956.GB7198@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326174956.GB7198@srcf.ucam.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the default behaviour of the kernel to use relatime for all
filesystems. This can be overridden with the "strictatime" mount
option.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 fs/namespace.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index d0659ec..f0e7530 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1920,6 +1920,9 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 	if (data_page)
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
+	/* Default to relatime */
+	mnt_flags |= MNT_RELATIME;
+
 	/* Separate the per-mountpoint flags */
 	if (flags & MS_NOSUID)
 		mnt_flags |= MNT_NOSUID;
@@ -1931,8 +1934,6 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags |= MNT_NOATIME;
 	if (flags & MS_NODIRATIME)
 		mnt_flags |= MNT_NODIRATIME;
-	if (flags & MS_RELATIME)
-		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_STRICTATIME)
 		mnt_flags &= ~(MNT_RELATIME | MNT_NOATIME);
 	if (flags & MS_RDONLY)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
