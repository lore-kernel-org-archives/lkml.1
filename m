Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbXJXNQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbXJXNQT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbXJXNQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:16:10 -0400
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:54702 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbXJXNQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:16:09 -0400
Date: Wed, 24 Oct 2007 14:15:40 +0100
From: Andy Whitcroft <andyw@uk.ibm.com>
To: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: 2.6.23-git18: ext2_check_page: bad entry in directory
Message-ID: <20071024131540.GV32058@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Seems that we are now getting strange errors mounting an ext2 root
filesystem under 2.6.23-git18:

  EXT2-fs error (device sda1): ext2_check_page: bad entry in directory #2:
  rec_len is smaller than minimal - offset=0, inode=0, rec_len=0,
  name_len=0

This seems to be occuring consistently since 2.6.23-git18.  I have been
back and rerun a -git17 job to confirm its not visible at that level.
This bug is expressing itself in 2.6.23-rc1 also.

I am suspicious of this commit in the -git17 -> -git18 block:

  commit 89910cccb8fec0c1140d33a743e72a712efd4f05
  Author: Jan Kara <jack@suse.cz>
  Date:   Sun Oct 21 16:41:40 2007 -0700

      ext2: avoid rec_len overflow with 64KB block size

/me goes debug this a bit more.

Jan?

-apw
