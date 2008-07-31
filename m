Return-Path: <linux-kernel-owner+w=401wt.eu-S1753754AbYGaQKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754AbYGaQKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 12:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYGaQK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 12:10:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38166 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYGaQK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 12:10:27 -0400
Date: Thu, 31 Jul 2008 17:10:24 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch resend] vfs: move executable checking into
	->permission()
Message-ID: <20080731161024.GL28946@ZenIV.linux.org.uk>
References: <E1KOBJb-0005L0-RF@pomaz-ex.szeredi.hu> <20080731003332.GJ28946@ZenIV.linux.org.uk> <E1KOWXe-0008Dl-ET@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KOWXe-0008Dl-ET@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 01:41:58PM +0200, Miklos Szeredi wrote:
> On Thu, 31 Jul 2008, Al Viro wrote:
> > On Wed, Jul 30, 2008 at 03:02:03PM +0200, Miklos Szeredi wrote:
> > >  static int coda_ioctl_permission(struct inode *inode, int mask)
> > >  {
> > > -        return 0;
> > > +	return check_execute(dentry->d_inode, mask);
> > >  }
> > 
> > Er?
> > 	a) mismerge from dentry-based variant
> 
> Yeah, crappy patch.  Agree on all other comments as well, thanks for
> the review.
 
Hrm...  OK, behaviour change for permission() on bdev/cdev/pipe is
not a problems...

I'll apply it, but if anybody has better suggestions for helper name,
please yell.  "execute_ok()" sounds very odd...
