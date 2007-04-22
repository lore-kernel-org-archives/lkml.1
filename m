Return-Path: <linux-kernel-owner+w=401wt.eu-S1753188AbXDVRnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbXDVRnY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 13:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbXDVRnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 13:43:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48463 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbXDVRnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 13:43:24 -0400
Date: Sun, 22 Apr 2007 10:40:51 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tejun Heo <htejun@gmail.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH RFD] alternative kobject release wait mechanism
Message-ID: <20070422174051.GA21680@kroah.com>
References: <20070421000340.GB12155@kroah.com> <Pine.LNX.4.44L0.0704211654080.12439-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0704211654080.12439-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 05:36:51PM -0400, Alan Stern wrote:
> On Fri, 20 Apr 2007, Greg KH wrote:
> 
> > > Greg, do you know of anything in particular that depends on a kobjects not 
> > > being released before their children are released?
> > 
> > Yes, the whole driver model :)
> 
> But anything in particular?  Looking through the source code, I see 
> kobj->parent gets used mainly by kobject_get_path() and not by much else.

Which is essencial for when a kobject is removed from the system and we
need to tell userspace which kobject it was.

> Looking some more, kobject_get_path() is used for kobject renaming,
> uevent handling, and a little bit in the input core.  None of these things 
> should try to access a kobject after it has been del()ed.  After all, it's 
> no longer present in the filesystem so it doesn't _have_ a path.

But we _have_ to have a full path at that time to tell userspace what
just went away.  That is the main reason we enforce this (there were
tons of issues with scsi devices and this in the past which is what
caused us to enforce this.)

thanks,

greg k-h
