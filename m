Return-Path: <linux-kernel-owner+w=401wt.eu-S1757333AbXD0VZx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333AbXD0VZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 17:25:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXD0VZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 17:25:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:58670 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333AbXD0VZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 17:25:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: Back to the future.
Date: Fri, 27 Apr 2007 22:44:07 +0200
User-Agent: KMail/1.9.5
Cc: Nigel Cunningham <nigel@nigel.suspend2.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177617379.4737.29.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704272244.08102.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 06:52, Pekka J Enberg wrote:
> On Thu, 2007-04-26 at 09:56 -0700, Linus Torvalds wrote:
> > >    which will map in the snapshot, return the mapped address and the size 
> > >    (and if you want to support snapshots > 4GB, be my guest, but I suspect 
> > >    you're actually *better* off just admitting that if you cannot shrink 
> > >    the snapshot to less than 32 bits, it's not worth doing)
>  
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > That inherently limits the image to half of available ram (you need
> > somewhere to store the snapshot), so you won't get the full image you
> > express interest in below.
> 
> It doesn't. We can make the userspace mapped pages copy-on-write. As long 
> as the userspace makes sure there's not much activity during 
> snapshot/shutdown, we will be fine. What we probably do need to copy is 
> kernel pages.

The user space is (and IMHO should be) frozen way before that and what you're
suggesting here is what I wanted to implement some time ago.  The problem with
this was that the user space pages may be updated, for example, by device
drivers as a result of some deferred I/O after we've snapshotted the system.

I didn't know how to find out which pages owned by the user space could be
updated this way, so I gave up at that time.

Greetings,
Rafael

