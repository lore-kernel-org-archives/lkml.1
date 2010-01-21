Return-Path: <linux-kernel-owner+w=401wt.eu-S1752290Ab0AUJFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab0AUJFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 04:05:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566Ab0AUJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 04:05:21 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60052 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0AUJFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 04:05:11 -0500
Date: Thu, 21 Jan 2010 04:05:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: zhou peng <ailvpeng25@gmail.com>, linux-security-module@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: About ACL for IPC Object
Message-ID: <20100121090510.GA908@infradead.org>
References: <6fb445941001200112o2934f805l4eb4f78000e9527e@mail.gmail.com> <6fb445941001200120m3aa5e944j54a6f645ce82d76f@mail.gmail.com> <4B57C3C3.9010606@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B57C3C3.9010606@schaufler-ca.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 07:02:27PM -0800, Casey Schaufler wrote:
> zhou peng wrote:
> > Hi all,
> >
> > There are ACL in file system, but why there are no ACL implementation
> > in IPC object, eg. shm, message queue, FIFO?
> >   
> 
> Most people haven't noticed that IPC objects are even there, much less
> that they have mode bits and not ACLs. Even when we were doing security
> evaluations on Unix boxes in the 1990's they were considered insufficiently
> interesting to justify the additional work to do ACLs.
> 
> If you really want ACLs on IPC objects it would make a dandy little
> project for a summer. I would be happy to review patches.

Or use the posix IPC mechanisms.  The Posix shared memory has ACL by
using tmpfs as the backing store, and we could add similar support to
Posix messages queues as they are also backed by a normal filesystem.

Adding this support to the old SYSV IPC mechanisms would be much harder
as they do not fit into the file backed model we use everywhere else at
all.

