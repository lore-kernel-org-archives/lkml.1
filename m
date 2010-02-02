Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0BBRL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:11:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51681 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756298Ab0BBRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:11:27 -0500
Date: Tue, 2 Feb 2010 12:11:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Catalin Marinas <catalin.marinas@arm.com>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, <linux-usb@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
Subject: Re: USB mass storage and ARM cache coherency
In-Reply-To: <201002021408.51851.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1002021208100.1805-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010, Oliver Neukum wrote:

> Am Dienstag, 2. Februar 2010 13:39:35 schrieb Catalin Marinas:
> > > For storage that is correct. But what about other sources of pages,
> > > for example iSCSI?
> > 
> > In the iSCSI case, does the HCD driver write directly to a page cache
> > page? Or it just fills in network packets that are copied to page cache
> > pages by the iSCSI code (sorry, I'm not familiar with this part of the
> > kernel). If the latter, the cache flushing in the HCD driver would not
> > help and it needs to be done in the iSCSI code.
> 
> As far as I can tell iSCSI does a private copy. But I don't know how
> many methods to transfer code pages over USB exist. I'd say the
> conservative solution is to flush for everything but control transfers.

This doesn't make any sense.  Nobody would ever use isochronous 
transfers to store data into a code page because isochronous is 
unreliable.  (Audio isn't a counterexample -- audio data may be mapped 
to userspace, but only to data pages, not code pages.  And the problem 
here is to maintain consistency between the D and I caches.)

In principle interrupt transfers could be used, but it is most
unlikely.  They are intended for bounded-latency transfers, not
transfers of potentially large amounts of data.

The only transfer type that makes sense to worry about is bulk.

Alan Stern

