Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbZD2VyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbZD2VyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 17:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbZD2Vx6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 17:53:58 -0400
Received: from thunk.org ([69.25.196.29]:60518 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198AbZD2Vx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 17:53:57 -0400
Date: Wed, 29 Apr 2009 17:53:44 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH RFC] ext3 data=guarded v5
Message-ID: <20090429215344.GD24749@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>, Jan Kara <jack@suse.cz>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Mike Galbraith <efault@gmx.de>
References: <1240941840.15136.44.camel@think.oraclecorp.com> <20090429085632.GA18273@duck.suse.cz> <1241014093.20099.28.camel@think.oraclecorp.com> <20090429191533.GB22936@duck.suse.cz> <1241034089.20099.60.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241034089.20099.60.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 03:41:29PM -0400, Chris Mason wrote:
> 
> I think my latest patch has this nailed down without the mutex.
> Basically it checks i_nlink with super lock held and then calls
> ext3_orphan_del.  If we race with unlink, we'll either find the new
> nlink count and skip the orphan del or unlink will come in after us and
> add the orphan back.

Can you make sure you mark any lock_super()'s with a comment saying
what it's protecting?  Eventually I suspect we'll want to forward port
this to ext4, and I have a patch in the ext4 patch queue that I mean
to backport to ext3 which introduces an explicit i_orphan_lock mutex
and eliminates most of the calls to lock/unlock_super() in support of
a cleanup which Christoph is planning.  So it'll make life easier if
you annotate any use of lock_super(), since it's going to be going
away in both ext3 and ext4 in the near future.

Thanks!!

							- Ted
