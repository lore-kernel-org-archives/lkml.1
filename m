Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYH1SXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYH1SXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbYH1SWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:22:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38265 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbYH1SWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:22:55 -0400
Date: Thu, 28 Aug 2008 11:14:06 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
Message-ID: <20080828181406.GA23898@kroah.com>
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org> <20080828175116.GB18461@kroah.com> <48B6E79E.6020702@kernel.org> <48B6E844.3050508@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B6E844.3050508@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 08:02:44PM +0200, Tejun Heo wrote:
> Tejun Heo wrote:
> > Greg KH wrote:
> >> Why do we need ioctls?  For CUSE?  In that case, would we need to copy
> >> the memory from userspace, into the kernel, and then back out into
> >> userspace again?  Can't we just have a "pass-through" type fixed ioctl
> >> instead?
> > 
> > Can you elaborate a bit?  How the fixed ioctl would know how much to
> > copy in and out and from where?
> 
> If you're worried about the double copying due to performance reasons,
> what we can do is implementing userspace to userspace copying.  I just
> took easier path of copying twice as u-u copy can't be done using the
> existing FUSE mechanics, but frankly, at this point, I think that would
> be an premature optimization.

No, I'm not worried about the performance, just that this should be
simple as we can just pass "arg" to userspace without touching it as it
just came from userspace, right?

Oh wait, there are process space issues at play here that I'm totally
forgetting about, right?

thanks,

greg k-h
