Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZCJW5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZCJW5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZCJW5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:57:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57636 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbZCJW5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:57:04 -0400
Date: Tue, 10 Mar 2009 15:54:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: hch@lst.de, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       konishi.ryusuke@lab.ntt.co.jp
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
Message-Id: <20090310155459.11ffa81f.akpm@linux-foundation.org>
In-Reply-To: <20090311.015542.118514963.ryusuke@osrg.net>
References: <20090311.015542.118514963.ryusuke@osrg.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 01:55:42 +0900 (JST)
Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> wrote:

> I've been working for the past serveral months to take review comments
> and to continually solve users' problems come up in mainling list

Yes, the maintenance has been impressive.

> (thanks for all giving comments and feedbacks!).  Also, I've tried to
> stabilize API and disk format to restrict additional changes and
> ensure backward compatibility.

Well.  From the point of view of mainline linux, there is no
back-compatibility issue, because the fs hasn't been merged yet.

You perhaps have back-compatibility concerns for existing users of the
out-of-tree patch, but I'd encourage you to not worry about that too
much - there will be fairly few users and they are probably pretty
technical and will be able to cope with a migration.  It's a _bit_ hard
on them but on the other hand, omitting back-compatibility code leads
to a better implementation for the long term.

What you should be more concerned about is forward-compatibility.  What
arrangements do you presently have in place to be able to later alter the
on-disk format without causing too much disruption?  Having a strong
design here will make changes easier to do and will lead to a better
filesystem.

Also..  Don't get _too_ concerned about freezing the on-disk format at
this time.  You could put in a mount-time printk("the nilfs on-disk
format may change at any time - do not place critical data on a nilfs
filesystem") and we leave that in place for a few months while things
stabilise.

And yes, I was planning on sending nilfs in to Linus for 2.6.30 unless
someone has decent-sounding reasons to hold it back.
