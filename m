Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab0BJL7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 06:59:41 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:47213 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0BJL7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 06:59:39 -0500
Date: Wed, 10 Feb 2010 11:59:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [WTF] ... is going on with current->fs->{root,mnt} accesses in
 pohmelfs
Message-ID: <20100210115938.GO30031@ZenIV.linux.org.uk>
References: <20100210100428.GL30031@ZenIV.linux.org.uk>
 <20100210101246.GA3509@ioremap.net>
 <20100210102422.GM30031@ZenIV.linux.org.uk>
 <20100210104515.GA6207@ioremap.net>
 <20100210110011.GN30031@ZenIV.linux.org.uk>
 <20100210111115.GA8376@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210111115.GA8376@ioremap.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 02:11:15PM +0300, Evgeniy Polyakov wrote:
> On Wed, Feb 10, 2010 at 11:00:11AM +0000, Al Viro (viro@ZenIV.linux.org.uk) wrote:
> > > > To mountpoint or to fs root?  And what's going on with d_find_alias()?
> > > 
> > > To root if it happend to be under mountpoint.
> > 
> > HUH?  How the hell can root of filesystem be under the mountpoint of
> > that filesystem?  What are you talking about?
> 
> Let me guess... Mmmm, it was in the yesterday newspaper, I remember.
> Maybe when we chroot somewhere. I meant not mounted fs root, but
> thread's root.

Why would a filesystem give a damn about the chroot of syscall originator
in the first place?

> > Why not use the dentries you've been given by VFS?
> 
> At writeback we do not have parents, so must find a path somehow.

Most of the places do have those just fine and unlike the writeback,
rename et.al. really care which pathname is being dealt with...

BTW, what prevents writeback vs. rename races?
