Return-Path: <linux-kernel-owner+w=401wt.eu-S1759029AbXGWPXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029AbXGWPXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752551AbXGWPXQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:23:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47964 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752546AbXGWPXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:23:16 -0400
Date: Mon, 23 Jul 2007 11:23:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: nigel@suspend2.net
cc: Paul Mackerras <paulus@samba.org>, <david@lang.hm>,
       Miklos Szeredi <miklos@szeredi.hu>, <linux-kernel@vger.kernel.org>,
       <miltonm@bga.com>, <ying.huang@intel.com>,
       <linux-pm@lists.linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
In-Reply-To: <200707231311.56398.nigel@nigel.suspend2.net>
Message-ID: <Pine.LNX.4.44L0.0707231120380.3545-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007, Nigel Cunningham wrote:

> Take a step back for a second.
> 
> The problem we're facing now is that we're getting some userspace threads, 
> used in processing I/O, that are functioning as exceptions to the "freeze 
> userspace, then freezeable kernel threads" rule. They are only exceptions 
> because of that role in processing I/O - because they're de facto kernel 
> threads. So, if we orient our thinking more in terms of I/O processing and 
> less in terms of the userspace/kernelspace distinction, we'll have a 
> solution:
> 
> 1) Freeze processes that aren't fs related (ie stop them generating I/O).

The problem here is that with things like FUSE, _every_ process is 
potentially fs related.  Nothing prevents a FUSE thread from doing IPC 
with any other thread.

> 2) Flush pending I/O.
> 3) Freeze filesystems in reverse order of dependency, the primary purpose 
> being to stop them generating further I/O on their metadata.
> 
> Locks that are being held are only being held because work is being done. If 
> we progressively focus on threads in terms of their create/process work 
> dependencies, we'll see that the problem isn't at all intractable.

As has been mentioned before, keeping track of all that dependency 
information would be very fragile and time-consuming.

Alan Stern

