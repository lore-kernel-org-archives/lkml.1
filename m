Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0BJLLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:11:18 -0500
Received: from genesysrack.ru ([195.178.208.66]:57495 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752984Ab0BJLLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:11:17 -0500
Date: Wed, 10 Feb 2010 14:11:15 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in pohmelfs
Message-ID: <20100210111115.GA8376@ioremap.net>
References: <20100210100428.GL30031@ZenIV.linux.org.uk> <20100210101246.GA3509@ioremap.net> <20100210102422.GM30031@ZenIV.linux.org.uk> <20100210104515.GA6207@ioremap.net> <20100210110011.GN30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210110011.GN30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 11:00:11AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > > To mountpoint or to fs root?  And what's going on with d_find_alias()?
> > 
> > To root if it happend to be under mountpoint.
> 
> HUH?  How the hell can root of filesystem be under the mountpoint of
> that filesystem?  What are you talking about?

Let me guess... Mmmm, it was in the yesterday newspaper, I remember.
Maybe when we chroot somewhere. I meant not mounted fs root, but
thread's root.

> > > AFAICS, you are doing that for regular files as well as directories,
> > > and you do support link(2) in there, so dentry (and path) obtained from
> > > that will be random.
> > 
> > Not exactly random, but can change.
> > Links support is rather subtle because of that, yes.
> > 
> > Plan was to add external attribute or increase inode size to include
> > parent name, but when I coded that it was so messy in respect of
> > renames, that was dropped.
> 
> Why not use the dentries you've been given by VFS?

At writeback we do not have parents, so must find a path somehow.

-- 
	Evgeniy Polyakov
