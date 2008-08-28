Return-Path: <linux-kernel-owner+w=401wt.eu-S1756130AbYH1RyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbYH1RyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbYH1RyB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:54:01 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbYH1RyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:54:00 -0400
Date: Thu, 28 Aug 2008 10:51:16 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <tj@kernel.org>
Cc: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] FUSE: implement ioctl support
Message-ID: <20080828175116.GB18461@kroah.com>
References: <1219945263-21074-1-git-send-email-tj@kernel.org> <1219945263-21074-6-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219945263-21074-6-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 02:41:01AM +0900, Tejun Heo wrote:
> ioctl support is tricky to implement because only the ioctl
> implementation itself knows which memory regions need to be read
> and/or written.  To support this, fuse client can request retry of
> ioctl specifying memory regions to read and write.  Deep copying
> (nested pointers) can be implemented by retrying multiple times
> resolving one depth of dereference at a time.

Why do we need ioctls?  For CUSE?  In that case, would we need to copy
the memory from userspace, into the kernel, and then back out into
userspace again?  Can't we just have a "pass-through" type fixed ioctl
instead?

thanks,

greg k-h
