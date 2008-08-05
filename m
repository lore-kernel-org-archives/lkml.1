Return-Path: <linux-kernel-owner+w=401wt.eu-S1765249AbYHEUyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765249AbYHEUyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758333AbYHEUyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:54:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58898 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762977AbYHEUyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:54:45 -0400
Date: Tue, 5 Aug 2008 21:36:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <greg@kroah.com>
Cc: Eric Paris <eparis@redhat.com>, malware-list@lists.printk.net,
       linux-kernel@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for
 on access scanning
Message-ID: <20080805213659.596eac48@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805170143.GA9639@kroah.com>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<20080805005132.GA3661@kroah.com>
	<20080805122503.73ea5416@lxorguk.ukuu.org.uk>
	<20080805170143.GA9639@kroah.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2008 10:01:43 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Aug 05, 2008 at 12:25:03PM +0100, Alan Cox wrote:
> > > Again, do it all in userspace (caching, and scanning).  I still really
> > > don't see the need to do this in the kernel becides it being "the way
> > > people have always done it."
> > 
> > We don't have notifiers for file segment changes that are scalable that
> > far.
> 
> I agree, but if we did, would that help out a lot here?  Lots of other
> groups of people are needing/asking for something like this and if
> someone can finally get it together to post something useful, that might
> be a very good thing.

A scalable notification scheme would certainly sort out content indexing
systems more nicely. Open notifiers that scale let you do path indexing
("People who opened file X also opened file Y" - both for optimising disk
layouts and for application level 'what do I prompt the user with' stuff)

The only thing  I can see that is actually needed to get the whole thing
working sweetly even for the virus and HSM cases is an LSM willing to
bounce some opens via a user space helper. Even without that you could
label content 'dubious' on close and relabel it accordingly in the
asynchronous scanning app

Alan
