Return-Path: <linux-kernel-owner+w=401wt.eu-S938127AbXHMC3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938127AbXHMC3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 22:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934545AbXHMC3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 22:29:14 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3398 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934170AbXHMC3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 22:29:13 -0400
Date: Sun, 12 Aug 2007 22:29:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Re: When to use a freezeable workqueue?
In-Reply-To: <200708130018.38652.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0708122222000.5743-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007, Rafael J. Wysocki wrote:

> On Sunday, 12 August 2007 10:11, Stefan Richter wrote:
> > In which situations is create_freezeable_workqueue() to be preferred
> > over create_singlethread_workqueue()?
> > 
> > Is a freezable worqueue preferable whenever the worker thread /can/ be
> > frozen, or is it only to be used if the thread /must/ be frozen during
> > suspend?
> 
> The latter, IMO.
> 
> Generally, if you want it to be frozen.

A good example of a reason for making a workqueue freezable is that the 
workqueue contains entries which would cause a suspended device to be 
resumed.  Obviously you don't want such things to happen while the 
system is going to sleep.  A little less obviously, there might also be 
problems if such a routine ran while the system was waking up.

Another reason might be that the workqueue contains entries which would
try to register or unregister a device.  Such actions aren't a good
idea at times when the PM core is iterating through a list of all
devices in order to suspend or resume them.  And in the future such
actions may block, effectively freezing the workqueue anyway -- which
could be troublesome if you don't want the workqueue to be frozen!

Alan Stern

