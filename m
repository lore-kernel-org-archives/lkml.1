Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbZDTWyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbZDTWyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 18:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756499AbZDTWyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 18:54:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39551 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756165AbZDTWx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 18:53:59 -0400
Date: Mon, 20 Apr 2009 15:50:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch] Wait for console to become available, ver 3
Message-Id: <20090420155033.a89ad4a0.akpm@linux-foundation.org>
In-Reply-To: <20090420223500.GB11068@cuplxvomd02.corp.sa.net>
References: <20090420143010.697c7380.akpm@linux-foundation.org>
	<Pine.LNX.4.44L0.0904201744410.6832-100000@iolanthe.rowland.org>
	<20090420151400.11afd62a.akpm@linux-foundation.org>
	<20090420223500.GB11068@cuplxvomd02.corp.sa.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 15:35:00 -0700
David VomLehn <dvomlehn@cisco.com> wrote:

> On Mon, Apr 20, 2009 at 03:14:00PM -0700, Andrew Morton wrote:
> > On Mon, 20 Apr 2009 17:51:16 -0400 (EDT)
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> ...
> > > What if a subsystem simply doesn't know in advance whether or not it's 
> > > going to register a console?  Or doesn't know when it has finished 
> > > probing all devices (since a new device could be plugged in at any 
> > > time)?
> > 
> > Fix it.  It's trivial to make a sub-driver call back into a higher
> > layer to tell it that it registered a console.  Or just do the
> > i_will_be_adding_a_console_soon()/oops_im_not_adding_a_console_after_all()
> > calls from the layer which _does_ know.
> 
> In the case of the console, we already have register_console(), which is
> what I'm using. I think your proposal will require adding code all over
> the place. And buses such as USB simply have no way of knowing whether they
> are done enumerating devices. A new device could take hours to come on line.

Add a timeout parameter to i_will_be_adding_a_console_soon().  (This
means that the how-long-to-wait-for policy is probably ahrd-coded into
the kernel which might be a problem).

> > Yes, a boot parameter is "simple" to inplement.  But it's ghastly from
> > a usability POV.  Especially if you care about boot times.  For how
> > long do you delay?  The user has to experiment with different delays
> > until he finds the magic number.  Then he adds 10% and waits for the
> > inevitable failure reports to come in.
> > 
> > It's much better to just get it right, even if that makes it more
> > "complex".
> 
> With USB, you just can't *ever* get it right. There is no limit on how
> long a device has to tell you its there. I wish this weren't the case,
> but our good friends in the USB world tell us that we have been lucky
> to have had USB consoles work as long as they have.

Sigh, OK, I appreciate the problem better.  But the proposed "solution"
is really quite fragile.  I expect that it will only prove usable in
highly controlled hardware setups.

Is my option a) any use?
