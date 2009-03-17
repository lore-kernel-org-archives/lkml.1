Return-Path: <linux-kernel-owner+w=401wt.eu-S1759079AbZCQSUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079AbZCQSUR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 14:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZCQSUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 14:20:00 -0400
Received: from ns1.suse.de ([195.135.220.2]:59680 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbZCQST7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 14:19:59 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ext4@vger.kernel.org
Subject: [PATCH 0/4] Fix bugs and possible data corruption if blocksize < pagesize
Date: Tue, 17 Mar 2009 18:33:51 +0100
Message-Id: <1237311235-13623-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hi,

  lately, I've been tracking some problems with ext3 reported by HP on ia64 and
this is what I came with. The first three patches fix real bugs - the first two
fix bugs in ext3 leading to false reports of EIO errors from JBD and aborted
journal, the third patch fixes a bug in block_write_full_page() which can
possibly lead to data corruption.
  With these patches, don't see the data corruption I was able to reproduce
with fsx-linux under UML. I'm not yet sure whether all the problems HP reported
are gone (they're testing now) but since this seems to be a nasty problem I'm
posting earlier rather than later. Please someone have a look whether my fix
and analysis looks sane. Thanks.

									Honza
