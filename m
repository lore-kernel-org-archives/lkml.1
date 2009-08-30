Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZH3AxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZH3AxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 20:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753043AbZH3AxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 20:53:02 -0400
Received: from netrider.rowland.org ([192.131.102.5]:44411 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752911AbZH3AxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 20:53:01 -0400
Date: Sat, 29 Aug 2009 20:53:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>, Zhang Rui <rui.zhang@intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/6] PM: Asynchronous resume of devices
In-Reply-To: <200908292117.06049.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908292048570.26533-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Aug 2009, Rafael J. Wysocki wrote:

> On Saturday 29 August 2009, Rafael J. Wysocki wrote:
> > On Saturday 29 August 2009, Alan Stern wrote:
> ...
> > > Strictly speaking, a new thread should be started only when needed.  
> > > That is, only when all the existing threads are busy running a 
> > > callback.  It shouldn't be too hard to keep track of when that happens.
> > 
> > The async framework does that for us. :-)
> 
> So, when I said "async threads", I should have rather said "async functions",
> because one async thread can execute multiple functions scheduled with
> async_schedule().
> 
> Taking that into consideration, it all works like this.  When there's a new
> async device to handle and there are no async threads available, a new thread
> is started and it runs the async function that handles the device and
> "opportunistically" searches dpm_list (once) for other device that are ready
> for handling.  After this function has returned, the thread goes to sleep and
> it only exits after being idle for 1 s.  In turn, when there's a new async
> device to handle and there are async threads available, on of them gets the
> async function to run.
> 
> I don't really think we can do much better than this in any other approach.

Since it obviously works and is relatively simple, I guess we ought to 
adopt it.

Alan Stern

