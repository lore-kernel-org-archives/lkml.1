Return-Path: <linux-kernel-owner+w=401wt.eu-S1754962AbZHLUlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbZHLUlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 16:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbZHLUlB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 16:41:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35008 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754884AbZHLUlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 16:41:00 -0400
Date: Wed, 12 Aug 2009 16:41:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add kerneldoc for flush_scheduled_work()
In-Reply-To: <1250108893.8829.10.camel@mulgrave.site>
Message-ID: <Pine.LNX.4.44L0.0908121635221.23954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Aug 2009, James Bottomley wrote:

> > I'll accept that.  However it means that the SCSI midlayer violates
> > your own locking rules with regard to the scan mutex.  Whereas if
> > flush_scheduled_work() were avoided, the locking rules would not be
> > violated.
> 
> Why do you think I've been trying to get rid of it?  Global mutexes
> covering large swathes of code are always a bad idea.  The async code
> already picked up a deadlock entanglement with it.

And yet it does serve an important purpose.

An alternative to that mutex would be to make all scanning and removal 
activities on a host funnel through a single thread.  Do you think that 
would be preferable?  (I'm not trying to be sarcastic -- this is a 
serious question.)


> > The rules for submission are _not_ the same.  With 
> > flush_scheduled_work():
> > 
> > 	Make sure that any lock you hold while flushing is private
> > 	and is not used (even indirectly) by any of your publicly 
> > 	exported routines.
> > 
> > With cancel_work_sync():
> > 
> > 	Make sure that any lock you hold while cancelling is not
> > 	used (even indirectly) by the work routine being cancelled.
> 
> The hair splitting has got to the point where I don't really care.  The
> point is that flush_scheduled_work() and cancel_work_sync() have similar
> problems.  Amazingly that was my original point.

And my original point was that the problems, though similar in nature, 
are harder to deal with in one case than in the other.

Alan Stern

