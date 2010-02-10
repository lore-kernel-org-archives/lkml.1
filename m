Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab0BJKMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 05:12:49 -0500
Received: from tservice.net.ru ([195.178.208.66]:36052 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753562Ab0BJKMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 05:12:47 -0500
Date: Wed, 10 Feb 2010 13:12:46 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in pohmelfs
Message-ID: <20100210101246.GA3509@ioremap.net>
References: <20100210100428.GL30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210100428.GL30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 10:04:28AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> a) pohmelfs_construct_path_string() will do interesting things if you
> call it while chrooted into jail and pohmelfs mounted deeper in that
> jail.  Try it.

Should it walk upto mountpoint?

> b) just why do we care about root of chroot jail in pohmelfs_path_length()?
> Not to mention anything else, current->fs->root/mnt may be changed under
> you if you share current->fs with another thread, but even aside of that,
> why does filesystem care about chroot of caller at all?
> 
> What's going on there?

It tries to construct a full path upto mountpoint. Effectively it should
do similar to non-exported dentry_path() things. There is a race between
getting buffer size and filling with the actual path, but we take care
about that by restarting if needed.

-- 
	Evgeniy Polyakov
