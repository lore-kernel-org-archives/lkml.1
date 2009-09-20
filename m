Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbZITSPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbZITSPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754767AbZITSPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:15:19 -0400
Received: from kroah.org ([198.145.64.141]:58317 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754723AbZITSPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:15:18 -0400
Date: Sun, 20 Sep 2009 11:11:33 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone
 VPA-II" ?
Message-ID: <20090920181133.GA14366@kroah.com>
References: <20090920150549.GC11621@kroah.com>
 <Pine.LNX.4.44L0.0909201308550.8307-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0909201308550.8307-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 20, 2009 at 01:12:29PM -0400, Alan Stern wrote:
> On Sun, 20 Sep 2009, Greg KH wrote:
> 
> > On Sun, Sep 20, 2009 at 03:39:57PM +0200, Tilman Schmidt wrote:
> > > When I connect my "T-Mobile MDA compact III" to my PC, running
> > > kernel 2.6.31 with openSUSE 10.3 userspace, I get exactly the
> > > symptoms described in:
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=8094
> > > 
> > > But that bug is marked as "CLOSED CODE_FIX", though reading through
> > > the comments I found no clear indication what was actually fixed,
> > > and from reading through the source files drivers/usb/serial/ipaq.c
> > > and drivers/usb/serial/usb-serial.c I get the impression that the
> > > problem of ipaq_open() oopsing because it gets called with
> > > port->read_urb==NULL is still present.
> 
> Interestingly, the fix from that bug report _was_ merged as commit
> 063a2da8f01806906f7d7b1a1424b9afddebc443 (written by me).  But then it
> was removed later on(!) in commits
> 07c3b1a1001614442c665570942a3107a722c314 and
> 9aebfd6bda789891e6d296bb49b5fb32d1057f18 (written by Greg).
> 
> Apparently the check should have been moved from the core into the 
> lower-level driver (i.e., ipaq.c) but it wasn't.  I don't know why; 
> maybe Greg does.

Yes, I missed the fact that the ipaq driver needed to pay attention to
this, my mistake :(

I'm pretty much not able to write any new patches until the end of next
week, due to conferences I'm currently attending, so if someone wants to
knock up a patch to fix this before then, it would be most appreciated.

thanks,

greg k-h
