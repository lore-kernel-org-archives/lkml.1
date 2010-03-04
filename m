Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab0CDNxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 08:53:39 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:34505 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750939Ab0CDNxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 08:53:38 -0500
Date: Thu, 4 Mar 2010 14:53:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
	userspace is frozen?
Message-ID: <20100304135337.GC12191@atrey.karlin.mff.cuni.cz>
References: <20100303215056.GB2579@ucw.cz> <Pine.LNX.4.44L0.1003031720530.1380-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1003031720530.1380-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > journalling assumptions broken: commit block is there, but previous
> > blocks are not intact. Data loss.
> > 
> > ...and that was the first I could think about. Lets not do
> >  this. Barriers were invented for a reason.
> 
> Very well.  Then we still need a solution to the original problem:  
> Devices sometimes need to be unregistered during resume, but
> del_gendisk() blocks on the writeback thread, which is frozen until
> after the resume finishes.  How do you suggest this be fixed?

Avoid unregistering device during resume. Instead, return errors until
resume is done and you can call del_gendisk? 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
