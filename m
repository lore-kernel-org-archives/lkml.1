Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbZITRM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbZITRM3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZITRM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:12:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:59949 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754682AbZITRM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:12:26 -0400
Date: Sun, 20 Sep 2009 13:12:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Tilman Schmidt <tilman@imap.cc>, <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
In-Reply-To: <20090920150549.GC11621@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0909201308550.8307-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Greg KH wrote:

> On Sun, Sep 20, 2009 at 03:39:57PM +0200, Tilman Schmidt wrote:
> > When I connect my "T-Mobile MDA compact III" to my PC, running
> > kernel 2.6.31 with openSUSE 10.3 userspace, I get exactly the
> > symptoms described in:
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=8094
> > 
> > But that bug is marked as "CLOSED CODE_FIX", though reading through
> > the comments I found no clear indication what was actually fixed,
> > and from reading through the source files drivers/usb/serial/ipaq.c
> > and drivers/usb/serial/usb-serial.c I get the impression that the
> > problem of ipaq_open() oopsing because it gets called with
> > port->read_urb==NULL is still present.

Interestingly, the fix from that bug report _was_ merged as commit
063a2da8f01806906f7d7b1a1424b9afddebc443 (written by me).  But then it
was removed later on(!) in commits
07c3b1a1001614442c665570942a3107a722c314 and
9aebfd6bda789891e6d296bb49b5fb32d1057f18 (written by Greg).

Apparently the check should have been moved from the core into the 
lower-level driver (i.e., ipaq.c) but it wasn't.  I don't know why; 
maybe Greg does.

Alan Stern

