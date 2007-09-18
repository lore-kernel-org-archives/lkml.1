Return-Path: <linux-kernel-owner+w=401wt.eu-S1756432AbXIRKjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756432AbXIRKjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 06:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbXIRKjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 06:39:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45091 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752282AbXIRKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 06:39:35 -0400
Date: Tue, 18 Sep 2007 20:39:16 +1000
From: David Chinner <dgc@sgi.com>
To: Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: 2.6.20 (XFS? related) crash after uptime of > 180 days during apt-get dist-upgrade on Debian Testing
Message-ID: <20070918103916.GV23367404@sgi.com>
References: <Pine.LNX.4.64.0709171315210.22156@p34.internal.lan> <20070918014537.GK23367404@sgi.com> <20070918092013.GA1352@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070918092013.GA1352@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2007 at 10:20:13AM +0100, Christoph Hellwig wrote:
> On Tue, Sep 18, 2007 at 11:45:37AM +1000, David Chinner wrote:
> > No idea - it looks like dkpg was trying to remove a directory on the
> > same path the lookup was and both have gone splat in __d_lookup on
> > the same dentry. Something happened in  those 180 days that left a
> > landmine that was tripped over here, I think. I can't see any way of
> > tracking it down from this, but thanks for reporting it anyway,
> 
> This looks a lot like the i_sem leak that Vlad debugged.  Do you remember
> where this was fixed?

The i_sem leak was hitting us on sles9 - 2.6.5 base kernel - and it was fixed
before the i_sem -> i_mutex conversion in mainline. Some time around 2.6.16,
IIRC. Given this was a 2.6.20 kernel, there'd be an almighty kaboom if that
bug still existed after the i_mutex conversion....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
