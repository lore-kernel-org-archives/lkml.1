Return-Path: <linux-kernel-owner+w=401wt.eu-S934125AbXHGUYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbXHGUYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 16:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbXHGUX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 16:23:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47741 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbXHGUX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 16:23:58 -0400
Subject: Re: [ckrm-tech] Circular Locking Dependency Chain detected in
	containers code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       ckrm-tech@lists.sourceforge.net
In-Reply-To: <6599ad830708071310i4fa7a98age169e2d650421d8b@mail.gmail.com>
References: <20070807062600.GH31148@linux.vnet.ibm.com>
	 <6599ad830708071310i4fa7a98age169e2d650421d8b@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 22:23:28 +0200
Message-Id: <1186518208.11797.176.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 13:10 -0700, Paul Menage wrote:
> I'm away from work at the moment and can't investigate fully, but it
> looks as though this may be the same one that I mentioned in the
> introductory email to the patchset. If so, it's a false positive -
> there's a point in the container mount code where we need to lock a
> newly-created (and hence guaranteed unlocked) directory inode while
> holding container mutex. This makes the lockdep code think that
> inode->i_mutex nests inside container_mutex, when in fact
> container_mutex nests outside inode->i_mutex in all cases except this
> one case where i_mutex can't possibly be locked.
> 
> I've not learned enough about lockdep yet to figure out how to shut it
> up in this case.

The typical annotation would be using spin_lock_nested/mutex_lock_nested
with a non-0 nesting level for this one case.

