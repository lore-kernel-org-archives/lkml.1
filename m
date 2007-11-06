Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbXKFSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbXKFSBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753695AbXKFSBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:01:03 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:51124 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXKFSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:01:02 -0500
Date: Tue, 6 Nov 2007 18:01:00 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [RFC] [PATCH 3/3] Recursive mtime for ext3
Message-ID: <20071106180100.GJ8181@ftp.linux.org.uk>
References: <20071106171537.GD23689@duck.suse.cz> <20071106171945.GG23689@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071106171945.GG23689@duck.suse.cz>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 06:19:45PM +0100, Jan Kara wrote:
> Implement recursive mtime (rtime) feature for ext3. The feature works as
> follows: In each directory we keep a flag EXT3_RTIME_FL (modifiable by a user)
> whether rtime should be updated. In case a directory or a file in it is
> modified and when the flag is set, directory's rtime is updated, the flag is
> cleared, and we move to the parent. If the flag is set there, we clear it,
> update rtime and continue upwards upto the root of the filesystem. In case a
> regular file or symlink is modified, we pick arbitrary of its parents (actually
> the one that happens to be at the head of i_dentry list) and start the rtime
> update algorith there.

*ewwww*

Nothing like undeterministic behaviour, is there?
 
> Intended use case is that application which wants to watch any modification in
> a subtree scans the subtree and sets flags for all inodes there. Next time, it
> just needs to recurse in directories having rtime newer than the start of the
> previous scan. There it can handle modifications and set the flag again. It is
> up to application to watch out for hardlinked files. It can e.g.  build their
> list and check their mtime separately (when a hardlink to a file is created its
> inode is modified and rtimes properly updated and thus any application has an
> effective way of finding new hardlinked files).

You know, you can do that with aush^H^Hdit right now...
