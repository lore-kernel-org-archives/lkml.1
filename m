Return-Path: <linux-kernel-owner+w=401wt.eu-S1754123AbZFELNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123AbZFELNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZFELNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:13:04 -0400
Received: from smtp.nokia.com ([192.100.122.233]:52207 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbZFELND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:13:03 -0400
From: Artem Bityutskiy <dedekind@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2.1 00/17] abstract out the super block clean/dirty state
Date: Fri,  5 Jun 2009 16:05:38 +0300
Message-Id: <1244207155-2092-1-git-send-email-dedekind@infradead.org>
X-Mailer: git-send-email 1.6.0.6
X-OriginalArrivalTime: 05 Jun 2009 11:12:42.0157 (UTC) FILETIME=[8B66E5D0:01C9E5CE]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is an updated sent of trivial patches which abstract out the super block
clean/dirty state. This is the same as v2, but it has 'sb_is_dirty()' renamed
to 'is_sb_dirty()'. The v2 patches were here:
http://marc.info/?l=linux-kernel&m=124410571830989&w=2

This patchset introduces the following 3 new helper VFS functions:

* static inline void mark_sb_dirty(struct super_block *sb)
* static inline void mark_sb_clean(struct super_block *sb)
* static inline int is_sb_dirty(struct super_block *sb)

With these patches the whole Linux kernel tree has only 3 places where
'sb->s_dirt' is referred.

These patches were previously sent as part of periodic write-back optimization
series here: http://marc.info/?l=linux-kernel&m=124342331127886&w=2

Because of the overlap with Jens' "per-bdi write-back" work, I have to work
on top of Jens' patches. However, it would be easier for me if my preparation
"abstracting sb->s_dirt" patches were merged earlier, at 2.6.31 merge window.
I think they make sense in general. I would then continue working on the second
part separately.

The patches were made on top of the VFS tree:
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git for-next

commit f932bb0daca28ffe69ec876043cac00bc9b50147
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue May 12 07:37:56 2009 -0400

    Fix nobh_truncate_page() to not pass stack garbage to get_block()

And they are also available at
git://git.infradead.org/users/dedekind/misc-2.6.git sb-helpers-v2

Thanks.
