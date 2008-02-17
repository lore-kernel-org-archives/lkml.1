Return-Path: <linux-kernel-owner+w=401wt.eu-S1757270AbYBQXb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbYBQXb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 18:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYBQXbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 18:31:50 -0500
Received: from relay2.sgi.com ([192.48.171.30]:34036 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754891AbYBQXbt (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 18:31:49 -0500
Date: Mon, 18 Feb 2008 10:31:23 +1100
From: David Chinner <dgc@sgi.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080217233123.GA155407@sgi.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B58EAA.8040405@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> Alasdair G Kergon wrote:
> > On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
> >> Implement barrier support for single device DM devices
> >  
> > Thanks.  We've got some (more-invasive) dm patches in the works that
> > attempt to use flushing to emulate barriers where we can't just
> > pass them down like that.
> 
> I wonder if it's worth the effort to try to implement this.
> 
> As far as I understand (*), if a filesystem realizes that the
> underlying block device does not support barriers, it will
> switch to using regular flushes instead

No, typically the filesystems won't issue flushes, either.

> - isn't it the same
> thing as you're trying to do on an MD level?
> 
> Note that a filesystem must understand barriers/flushes on
> underlying block device, since many disk drives don't support
> barriers anyway.
> 
> (*) this is, in fact, an interesting question.  I still can't
> find complete information about this.  For example, how safe
> xfs is if barriers are not supported or turned off?  Is it
> "less safe" than with barriers?  Will it use regular cache
> flushes if barriers are not here?

Try reading at the XFS FAQ:

http://oss.sgi.com/projects/xfs/faq/#wcache

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
