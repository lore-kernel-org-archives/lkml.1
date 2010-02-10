Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0BJNaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 08:30:11 -0500
Received: from broadrack.ru ([195.178.208.66]:36346 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0BJNaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 08:30:09 -0500
Date: Wed, 10 Feb 2010 16:30:07 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in pohmelfs
Message-ID: <20100210133007.GA17744@ioremap.net>
References: <20100210100428.GL30031@ZenIV.linux.org.uk> <20100210101246.GA3509@ioremap.net> <20100210102422.GM30031@ZenIV.linux.org.uk> <20100210104515.GA6207@ioremap.net> <20100210110011.GN30031@ZenIV.linux.org.uk> <20100210111115.GA8376@ioremap.net> <20100210115938.GO30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210115938.GO30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 11:59:39AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > Let me guess... Mmmm, it was in the yesterday newspaper, I remember.
> > Maybe when we chroot somewhere. I meant not mounted fs root, but
> > thread's root.
> 
> Why would a filesystem give a damn about the chroot of syscall originator
> in the first place?

That's the point - it is not needed.

> > > Why not use the dentries you've been given by VFS?
> > 
> > At writeback we do not have parents, so must find a path somehow.
> 
> Most of the places do have those just fine and unlike the writeback,
> rename et.al. really care which pathname is being dealt with...

POHMELFS uses writeback cache also for metadata, so effectively most of
such operations are also postponed. Later I turned that off though.

> BTW, what prevents writeback vs. rename races?

There are proper locks for such operations.

-- 
	Evgeniy Polyakov
