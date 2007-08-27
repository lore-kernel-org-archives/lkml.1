Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbXH0W7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbXH0W7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 18:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752626AbXH0W7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 18:59:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbXH0W7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 18:59:20 -0400
Date: Mon, 27 Aug 2007 23:59:01 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [RFC] block_device_operations prototype changes
Message-ID: <20070827225901.GB30122@agk.fab.redhat.com>
Mail-Followup-To: Al Viro <viro@ftp.linux.org.uk>,
	linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, axboe@kernel.dk
References: <20070827103053.GF21089@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827103053.GF21089@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 11:30:53AM +0100, Al Viro wrote:
> 3) ->ioctl().  What a mess...  

Yup.

See also:
  Subject: [PATCH] dm: support ioctls on mapped devices: fix with fake file
  http://uwsg.indiana.edu/hypermail/linux/kernel/0606.2/2979.html

and related threads.

> First of all, we have 3 methods with different
> calling conventions:
> 	->ioctl(inode, file, cmd, arg)
> 	->unlocked_ioctl(inode, file, cmd, arg)

When I last looked it was:
  long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
with the lack of inode forcing dm to use ->ioctl (because file can be NULL when
only the block device is known) and immediately drop the pointless-for-us
lock!

Alasdair
-- 
agk@redhat.com
