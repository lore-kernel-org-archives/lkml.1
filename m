Return-Path: <linux-kernel-owner+w=401wt.eu-S1761257AbZFWRC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761257AbZFWRC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 13:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761220AbZFWRCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 13:02:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55946 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761131AbZFWRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 13:02:13 -0400
Date: Tue, 23 Jun 2009 13:02:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <magnus.damm@gmail.com>,
       <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update 3] PM: Introduce core framework for run-time PM
 of I/O devices
In-Reply-To: <200906221749.50784.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906231043290.3209-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Rafael J. Wysocki wrote:

> > And of course, synchronous pm_runtime_resume should always increment the 
> > counter.
> 
> Sure.

Now that I've thought about it some more, I decided that we might want
to be more flexible.  Without subjecting you to the entire line of
reasoning, let's just say that I'm starting to wonder whether it's such
a good idea to tie the counter increments to the PM core runtime resume
calls at all.

Maybe it would be better (easier to use, less constraining) to require
the runtime_resume callback to do its own pm_runtime_get.  That way the
driver would be entirely responsible for managing the usage counter;
the PM core wouldn't be involved.  pm_runtime_get would simply
increment the counter, so it could be used even in interrupt context.  
At the moment, I don't see any need for it to queue an autoresume
request if the device happens to be suspended.

Something like this was probably your intention all along.  :-)

Alan Stern

