Return-Path: <linux-kernel-owner+w=401wt.eu-S1752451AbZI0T4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbZI0T4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZI0T4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:56:16 -0400
Received: from cantor.suse.de ([195.135.220.2]:38438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZI0T4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:56:16 -0400
Date: Sun, 27 Sep 2009 21:56:19 +0200
From: Nick Piggin <npiggin@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/33] fs: brlock vfsmount_lock
Message-ID: <20090927195619.GG6327@wotan.suse.de>
References: <20090904065142.114706411@nick.local0.net> <20090904065534.447753909@nick.local0.net> <20090922151751.GM5858@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090922151751.GM5858@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 04:17:51PM +0100, Al Viro wrote:
> On Fri, Sep 04, 2009 at 04:51:45PM +1000, npiggin@suse.de wrote:
> > Use a brlock for the vfsmount lock.
> 
> I like it, but I'd like to see how costly it becomes on heavily SMP boxen.
> Creation/removal of bindings as load...

I could test that... Is there some realistic scenario I can try
to implement that exercises this? (failing that, I'll happily
do a microbenchmark).

I was thinking it *might* be possible to do RCU... but especially
coming up with a scheme that avoids synchronize_rcu() in the
umount path is not trivial, so perhaps the simple read/write
annotations with brlock behind the scenes is a more reasonable step.

I do also actually owe you some documentation with this one too,
which I will get around to adding.

