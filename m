Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXKELJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXKELJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbXKELJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:09:28 -0500
Received: from styx.suse.cz ([82.119.242.94]:42903 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753891AbXKELJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:09:27 -0500
Date: Mon, 5 Nov 2007 12:09:26 +0100
From: Jan Kara <jack@suse.cz>
To: Olaf Dietsche <olaf+list.linux-kernel@olafdietsche.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 2.6.23: Filesystem capabilities 0.17
Message-ID: <20071105110925.GC9561@duck.suse.cz>
References: <871wbhc0zj.fsf@olafdietsche.de> <20071031170853.GD28809@atrey.karlin.mff.cuni.cz> <87tzo5925v.fsf@olafdietsche.de> <20071101215424.GA27788@duck.suse.cz> <87fxzp8v2c.fsf@olafdietsche.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fxzp8v2c.fsf@olafdietsche.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 01-11-07 23:22:51, Olaf Dietsche wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Thu 01-11-07 20:49:32, Olaf Dietsche wrote:
> >> Jan Kara <jack@suse.cz> writes:
> >> 
> >> >> This patch implements filesystem capabilities. It allows to
> >> >> run privileged executables without the need for suid root.
> >> >   Hmm, is there some "design document" so that one does not have to poke
> >> > through the code and find out what it's actually trying to do?
> >> 
> >> What do you mean with "trying to do"? I thought this is obvious, it
> >> provides executables with filesystem capabilities.
> >   Well, yes, that was obvious but I rather meant "how is it doing it?".
> > So where does it store these bits and such.
> 
> The bits are stored in a sparse file named /.capabilities in the
> directory of the mount point, where the corresponding executable
> lives. The inode number of the file is the index into this file.
  Thanks for explanation. I guess I should warn you a bit :) Quota stores
it's data (which are in a certain sence filesystem metadata) in regular
files and believe me it brings some unexpected complexity. Especially
avoiding deadlocks with journaled filesystems was quite complex for quotas
(you cannot call filesystem write function when a transaction is already
started or deadlocks can happen).
  I guess with capabilities you need to write to the file only in some
special situations but still you could have problems with that.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
