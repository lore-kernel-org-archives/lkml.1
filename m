Return-Path: <linux-kernel-owner+w=401wt.eu-S1751480AbXFKLGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480AbXFKLGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 07:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbXFKLFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 07:05:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:56125 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXFKLFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 07:05:48 -0400
Date: Mon, 11 Jun 2007 13:05:47 +0200
From: Jan Kara <jack@suse.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Tweedie <sct@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext3fs: umount+sync not enough to guarantee metadata-on-disk
Message-ID: <20070611110547.GA26561@atrey.karlin.mff.cuni.cz>
References: <46680BB8.50404@rtr.ca> <20070607084142.42583639.akpm@linux-foundation.org> <46682E4E.1070303@redhat.com> <46687C05.1080408@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46687C05.1080408@rtr.ca>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Chuck Ebbert wrote:
> >On 06/07/2007 11:41 AM, Andrew Morton wrote:
> >>>   mount /var/lib/mythtv -oremount,ro
> >>>   sync
> >>>   umount /var/lib/mythtv
> >>Did this succeed?  If the application is still truncating that file, the
> >>umount should have failed.
> >
> >Shouldn't sync should wait for truncate to finish?
> 
> The part that gets me here, and that others might be missing,
> is that we are not waiting for ftruncate at this point.
> 
> We're waiting for unlink.  The application that was doing ftruncate
> in tiny little doses has been sent a kill-9 signal, so what should
> be happening now (confirmed by disk activity LEDs) is the file should
> just be getting deleted the same as if we did "rm bigfile" on it.
  But if that app has been waiting in D state, kill -9 does nothing to it
until it wakes up, doesn't it? So fd's are still open and umount fails.

 								Honza 
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
