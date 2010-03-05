Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab0CEEil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:38:41 -0500
Received: from THUNK.ORG ([69.25.196.29]:45254 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab0CEEik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:38:40 -0500
Date: Thu, 4 Mar 2010 23:38:22 -0500
From: tytso@mit.edu
To: Eric Sandeen <sandeen@redhat.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: dump/restore not supported for ext4
Message-ID: <20100305043822.GA5747@thunk.org>
Mail-Followup-To: tytso@mit.edu, Eric Sandeen <sandeen@redhat.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <alpine.DEB.2.00.1003041704230.17723@p34.internal.lan>
 <4B90419E.20309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B90419E.20309@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 04, 2010 at 05:26:22PM -0600, Eric Sandeen wrote:
> Justin Piszcz wrote:
> > Hi,
> > 
> > I should have researched it more:
> > 
> > http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=511651
> > https://lists.ubuntu.com/archives/universe-bugs/2009-June/098729.html
> > 
> > Looks like it's broken, I agree with the reporters, dump should abort if
> > it is dealing with an ext4 filesystem, since you cannot restore data
> > from an ext4 dump.
> 
> does dump still read the mounted block device directly?  I'm not familiar
> with the internals (need to look, I guess) but if so, I wonder how that
> + delalloc get along...

It does read the mounted block device directly, and so it's certainly
not a _recommended_ way to back up your ext4 filesystem.  It should
work, though, since it just uses the high-level libext2fs functions
--- and a while back, I think I did a quick test and found that it
really did work.  So I'm not sure what broke, but it might not be that
hard to fix.  That being said, it may not be worth it to fix it, since
with delayed allocation, backups using dump will be even more
unreliable than they were before.

						- Ted
