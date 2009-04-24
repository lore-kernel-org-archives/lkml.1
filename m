Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbZDXIui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbZDXIui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 04:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZDXIu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 04:50:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42242 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZDXIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 04:50:26 -0400
Date: Fri, 24 Apr 2009 04:50:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424085017.GB28592@infradead.org>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424080634.GG24912@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 10:06:34AM +0200, Ingo Molnar wrote:
> 
> You've not replied to my request (attached below) to put these 
> trivial BKL-pushdown bits into a separate branch/tree and not into 
> the VFS tree. You've now mixed that commit with other VFS changes.
> 
> Had it been in a separate branch, and had we tested it, Linus could 
> have pulled the trivial BKL pushdown bits out of normal merge order 
> as well. That is not possible now.

It shouldn't be pushed out of order.  It's a normal VFS locking change
and should be pushed with the next VFS push for 2.6.31.

> Furthermore, by doing this you are also hindering the 
> tip:kill-the-BKL effort (which has been ongoing for a year chipping 
> away at various BKL details) which facilitated these changes. 
> Alessio did these fixes to fix bugs he can trigger in that tree.
> 
> You've also not explained why you have done it this way. It would 
> cost you almost nothing to apply these bits into a separate branch 
> and merge that branch into your main tree. Lots of other maintainer 
> are doing that.

Having a separate kill the BKL tree is a stupid idea.  Locking changes
need deep subsystem knowledge and should always go through the subsystem
trees.

