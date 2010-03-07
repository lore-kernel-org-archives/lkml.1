Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0CGCey (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 21:34:54 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38837 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447Ab0CGCex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 21:34:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=uOCA2hJkTy9Rx2zoqHFDHkxx8G+5lRj9BqbeGHHpSOezKXY0luATupZjzZP0Ov+upm
         6ZUaJMHEXkHPYVl9uBwT1phbCRILuiXBYdSExED9Po+oRFRpamEBZTjkE6rR9cCBV63R
         VspUd/HpBKfbHzXBNyI6v7V8JqII7hq6SxXUA=
Date: Sat, 6 Mar 2010 21:28:47 -0500 (EST)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: parag@parag-laptop
To: linux-kernel@vger.kernel.org
cc: david@fromorbit.com
Subject: UML XFS link error list_sort
Message-ID: <alpine.DEB.2.00.1003062118240.19862@parag-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave

While building today's git for CONFIG_UML, I got a link error (list_sort 
undefined) for xfs.ko.

Currently I am working around it with the below hack. Not sure the right 
thing to do would be some where at the arch level for UML or if the below 
would be appropriate.

Parag

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index b4769e4..2905cda 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -94,6 +94,8 @@ xfs-y				+= xfs_alloc.o \
 
 xfs-$(CONFIG_XFS_TRACE)		+= xfs_btree_trace.o
 
+xfs-$(CONFIG_UML)		+= ../../lib/list_sort.o
+
 # Objects in linux/
 xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   kmem.o \
