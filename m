Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbZBQD0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbZBQD0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:26:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbZBQD0g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:26:36 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1899 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750960AbZBQD0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:26:36 -0500
Date: Mon, 16 Feb 2009 22:26:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arve =?UTF-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       mark gross <mgross@linux.intel.com>,
       "Woodruff, Richard" <r-woodruff2@ti.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
In-Reply-To: <20090216185758.1a4d041d@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0902162220420.24097-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Feb 2009, Arjan van de Ven wrote:

> > > shouldn't idle timeout etc be internal to the driver?
> > > Yes policy preferences / constraints makes sense to communicate,
> > > actual settings do not. For one they keep changing fast all the time
> > > anyway.
> > 
> > Sorry, I don't agree.  A single driver may control many different
> > kinds of device -- it may not even be aware of the distinction!
> > Consider the SCSI disk driver: It has to handle both traditional
> > rotating media and solid-state disks.  Clearly they should have
> > different runtime PM parameters.  But the driver isn't in a good
> > position to know what those parameters should be.
> 
> ... and userspace is ?

Certainly it is.  Programs like hal can maintain databases of device 
IDs and appropriate timeout values, and allow the user to change the 
values as needed.  Such databases don't belong in the kernel.

Furthermore, the user may have a better idea of the kind of workload he
wants to impose and his latency requirements than the kernel does.

> Sorry I don't buy that. Kernel is supposed to abstract the hardware...
> That's its fundamental task. Now if the driver doesn't know it can get
> help from the subsystem, that's perfectly fine.

There are various levels of abstraction.  If the kernel really 
abstracted _everything_ then we wouldn't need ioctl.  :-)

> (and quiet often the kernel gets updated more often as the userspace)

(That's hardly a valid argument for putting something into the kernel
when it belongs in userspace.)

Alan Stern

