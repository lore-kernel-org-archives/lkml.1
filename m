Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbYKQSvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbYKQSvQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYKQSvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:51:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35324 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657AbYKQSu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:50:59 -0500
Date: Mon, 17 Nov 2008 10:50:50 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: Peter Palfrader <peter@palfrader.org>, linux-kernel@vger.kernel.org
Subject: Re: Fix broken ownership of /proc/sys/ files
In-Reply-To: <20081117040645.GS28946@ZenIV.linux.org.uk>
Message-ID: <alpine.LFD.2.00.0811171049480.3468@nehalem.linux-foundation.org>
References: <20081116205922.GI28958@anguilla.noreply.org> <20081116221910.GQ28946@ZenIV.linux.org.uk> <alpine.LFD.2.00.0811161515040.9657@nehalem.linux-foundation.org> <20081117040645.GS28946@ZenIV.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 17 Nov 2008, Al Viro wrote:
> > 
> > We already initialize a _lot_ of fields, including fields that most 
> > filesystem would likely end up re-initializing when reading an inode (like 
> > i_size and i_nlink). Maybe it would be more sensible to initialize 
> > i_gid/uid there too, when we are guaranteed to have that cacheline dirty 
> > anyway (because we're initializing everything around those fields).
> 
> *nod*
> 
> It certainly makes sense to do it in a uniform way - there's enough
> users of new_inode() that want exactly that.  I'll do that as soon
> as I get from under a huge pile of pending mail ;-/

Ok. I think zeroing i_mode might be a good idea too. Just to make sure..

> ObPendingStuff: would you mind a series of section annotations?  That's
> a bunch of trivial one-liners and it kills the section noise - the remaining
> ones are few and tricky.  It had sat around in my tree for several weeks
> and I can certainly carry it until the next cycle, but OTOH this stuff
> *is* trivial and the noise is annoying as hell.

Yeah, it would be good to get rid of at least the bulk of the section 
warnings. A lot of them have historically been 100% real problems.

		Linus
