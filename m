Return-Path: <linux-kernel-owner+w=401wt.eu-S1762050AbZFPTOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762050AbZFPTOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 15:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759254AbZFPTOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 15:14:10 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33381 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbZFPTOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 15:14:09 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20090616191410.D14714CA49E@norville.austin.ibm.com>
Date: Tue, 16 Jun 2009 14:14:10 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This fixes a regression introduced in 2.6.30.  I'll send it to stable as well.

This will update the following files:

 fs/jfs/jfs_extent.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

through these ChangeSets:

commit f7c52fd17a7dda42fc9e88c2b2678403419bfe63
Author: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Date:   Tue Jun 16 13:43:22 2009 -0500

    jfs: fix regression preventing coalescing of extents
    
    Commit fec1878fe952b994125a3be7c94b1322db586f3b caused a regression in
    which contiguous blocks being allocated to the end of an extent were
    getting a new extent created.  This typically results in files entirely
    made up of 1-block extents even though the blocks are contiguous on
    disk.
    
    Apparently grub doesn't handle a jfs file being fragmented into too many
    extents, since it refuses to boot a kernel from jfs that was created by
    the 2.6.30 kernel.
    
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
    Reported-by: Alex <alevkovich@tut.by>
