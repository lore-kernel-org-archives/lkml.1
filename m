Return-Path: <linux-kernel-owner+w=401wt.eu-S1758616AbYEENNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616AbYEENNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYEENNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:13:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57809 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973AbYEENNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:13:10 -0400
Date: Mon, 5 May 2008 14:13:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Enrico Weigelt <weigelt@metux.de>
Cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: VFS + path walktrough
Message-ID: <20080505131307.GM5882@ZenIV.linux.org.uk>
References: <20080505124041.GB32019@nibiru.local> <20080505130623.GC32019@nibiru.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505130623.GC32019@nibiru.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 03:06:23PM +0200, Enrico Weigelt wrote:

> We could just add another call vector to struct file_operations,
> as replacement for link_path_walk() - if it's zero, the original
> function is used. This way an filesystem can do the walktrough
> by it's own, but doesn't need to.
> 
> 
> What do you think about this ?

That you have quite forgotten about mounts.  And we *REALLY* don't
want to shift the entire logics of link_path_walk() into filesystems -
this is insane.  Even "let's follow that symlink" part alone, not to
mention mountpoint handling, populating dcache, etc.
