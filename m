Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab0BJKEd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:04:33 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58145 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242Ab0BJKEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:04:32 -0500
Date: Wed, 10 Feb 2010 10:04:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: zbr@ioremap.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [WTF] ... is going on with current->fs->{root,mnt} accesses in
 pohmelfs
Message-ID: <20100210100428.GL30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a) pohmelfs_construct_path_string() will do interesting things if you
call it while chrooted into jail and pohmelfs mounted deeper in that
jail.  Try it.

b) just why do we care about root of chroot jail in pohmelfs_path_length()?
Not to mention anything else, current->fs->root/mnt may be changed under
you if you share current->fs with another thread, but even aside of that,
why does filesystem care about chroot of caller at all?

What's going on there?
