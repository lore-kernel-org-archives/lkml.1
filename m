Return-Path: <linux-kernel-owner+w=401wt.eu-S1765194AbZFOSAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765194AbZFOSAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765046AbZFOR75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:59:57 -0400
Received: from cantor.suse.de ([195.135.220.2]:46682 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764723AbZFOR75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:59:57 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, npiggin@suse.de
Subject: [PATCH 0/10] Fix page_mkwrite() for blocksize < pagesize (version 3)
Date: Mon, 15 Jun 2009 19:59:47 +0200
Message-Id: <1245088797-29533-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


patches below are an attempt to solve problems filesystems have with
page_mkwrite() when blocksize < pagesize (see the changelog of the second patch
for details).

Could someone please review them so that they can get merged - especially the
generic VFS/MM part? It fixes observed problems (WARN_ON triggers) for ext4 and
makes ext2/ext3 behave more nicely (mmapped write getting page fault instead
of silently discarding data).

The series is against Linus's tree from today. The differences against previous
version are one bugfix in ext3 delalloc implementation... Please test and review.
Thanks.

									Honza
