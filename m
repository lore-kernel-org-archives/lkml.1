Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbYFWOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbYFWOlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756182AbYFWOlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:41:03 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35215 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbYFWOlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:41:02 -0400
Date: Mon, 23 Jun 2008 15:41:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 2/3] vfs: fix sys_getcwd for detached mounts
Message-ID: <20080623144101.GY28946@ZenIV.linux.org.uk>
References: <20080616112804.930095761@szeredi.hu> <20080616112828.731144133@szeredi.hu> <20080623135549.GW28946@ZenIV.linux.org.uk> <E1KAn7I-0007E6-St@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KAn7I-0007E6-St@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 04:34:00PM +0200, Miklos Szeredi wrote:
> > > After the patch it will give a much saner "/skel" result.
> > 
> > I'm not sure that /skel is much saner, to be honest.
> 
> Just for argument's sake: before the patch getcwd() on detached object
> wasn't consistent with any definition of "absolute path".  After the
> patch it's at least consistent with defining it as the path from the
> ultimate reachable ancestor (which does have at least some historical
> relevance).

Before the patch getcwd() on detached object generated junk, period.
As for the path from ultimate reachable ancestor...  I'm not sure that
this definition actually matches any real-world problem.
 
> >  Existing
> > behaviour is BS, no arguments about that, but I suspect that
> > we want that to be recognizable.  How about doing something
> > like detached:<rest of path> instead (c.f. "pipe:[6969]" and
> > its ilk)?
> 
> OK, obviously current users don't care, otherwise somebody would have
> complained about this issue.  So if we agree on "detached:...", I'm
> fine with that.

Care to resend?  BTW, one more thing - in the 1/3 I'd probably add a
wrapper around prepend() that would take struct qstr * instead of
name/length and used it instead of your locals.  As in
	prepend_name(&end, &buflen, &dentry->d_name)
etc.
