Return-Path: <linux-kernel-owner+w=401wt.eu-S1758119AbZEKTLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119AbZEKTLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754426AbZEKTLn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:11:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43087 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909AbZEKTLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:11:43 -0400
Date: Mon, 11 May 2009 20:11:42 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] dup2: Fix return value with oldfd == newfd and invalid
	fd
Message-ID: <20090511191142.GK8633@ZenIV.linux.org.uk>
References: <4A086D9E.60308@suse.com> <alpine.LFD.2.01.0905111135560.3586@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905111135560.3586@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 11, 2009 at 11:40:56AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 11 May 2009, Jeff Mahoney wrote:
> > 
> >  The return value of dup2 when oldfd == newfd and the fd isn't valid is not
> >  getting properly sign extended. We end up with 4294967287 instead of -EBADF.
> 
> Indeed.
> 
> >  This patch uses a signed int for the error value so it is properly extended.
> 
> However, I'd rather move the new variable into the block where it is used, 
> and keep the whole corner-case thing self-contained.
> 
> So can you verify that this trivial variation on the patch is ok by you, 
> and I'll commit it as yours with your message? (I realize it's really 
> trivial, and I could just do this myself, but good to get the change 
> ack'ed anyway).

I'm not sure that it's a right fix, actually.  Note that userland declaration
of that sucker is int dup2(int, int); so should we really take unsigned int
as arguments?
