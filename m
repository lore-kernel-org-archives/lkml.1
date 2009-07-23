Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZGWS1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZGWS1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 14:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbZGWS1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 14:27:43 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:54137 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbZGWS1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 14:27:41 -0400
To: torvalds@linux-foundation.org
Subject: [GIT PULL] jfs update
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Message-Id: <20090723182740.581D61276F9@norville.austin.ibm.com>
Date: Thu, 23 Jul 2009 13:27:40 -0500 (CDT)
From: shaggy@linux.vnet.ibm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git for-linus

This fixes a regression from 2.6.30 and will update the following files:

 fs/jfs/acl.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

through this ChangeSet:

commit 4a19fb11a90fdbbcb3bc02effa036230d035ca28
Author: Stefan Bader <stefan.bader@canonical.com>
Date:   Thu Jul 23 11:26:05 2009 +0200

    jfs: Fix early release of acl in jfs_get_acl
    
    BugLink: http://bugs.launchpad.net/ubuntu/+bug/396780
    
    Commit 073aaa1b142461d91f83da66db1184d7c1b1edea "helpers for acl
    caching + switch to those" introduced new helper functions for
    acl handling but seems to have introduced a regression for jfs as
    the acl is released before returning it to the caller, instead of
    leaving this for the caller to do.
    This causes the acl object to be used after freeing it, leading
    to kernel panics in completely different places.
    
    Thanks to Christophe Dumez for reporting and bisecting into this.
    
    Reported-by: Christophe Dumez <dchris@gmail.com>
    Tested-by: Christophe Dumez <dchris@gmail.com>
    Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
    Acked-by: Andy Whitcroft <apw@canonical.com>
    Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
