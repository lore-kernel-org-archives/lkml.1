Return-Path: <linux-kernel-owner+w=401wt.eu-S1758952AbZGIG6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758952AbZGIG6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 02:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbZGIG6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 02:58:06 -0400
Received: from smtp.nokia.com ([192.100.122.230]:39768 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbZGIG6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 02:58:05 -0400
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-fsdevel@vger.kernel.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 09 Jul 2009 11:48:22 +0300
Message-Id: <20090709084822.12122.79749.sendpatchset@localhost.localdomain>
Subject: [PATCH v3 00/18] periodic write-back timer optimization
X-OriginalArrivalTime: 09 Jul 2009 06:57:53.0966 (UTC) FILETIME=[94F994E0:01CA0062]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al, Jens,

this is the third or fourth attempt. Al, would you please take a look
at this? Would it be possible to get your ack and then merge this
via Jens' tree?

The patches attempt to optimize the periodic write-back and stop it when
there are no dirty data. IOW, we do not want the thread to wake up every
5 seconds (by default), find there is nothing to do, and so on. We want
to save power instead.

The patches are against Jens Axboe's per-bdi write-back tree. Namely,
against:

git://git.kernel.dk/linux-2.6-block.git writeback-v12

Patches 01-16 introduce 2 VFS helpers and wrap all 'sb->s_dirt'
manipulations.

Patch 17 re-names s_dirt to s_dirty in order to make sure we catch
all direct s_dirt accesses.

Patch 18 optimizes the periodic 'sync_supers' thread. This used
to be 'pdflush', but Jens re-worked this area and now it is called
'sync_supers'. By the way, with Jens' changes the former kupdated stuff
stuff looks a lot cleaner and it is easier to work on top of that.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
