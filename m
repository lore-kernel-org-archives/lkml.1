Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbXGDP5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbXGDP5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 11:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbXGDP5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 11:57:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1117 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752609AbXGDP5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 11:57:15 -0400
Date: Wed, 4 Jul 2007 11:57:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM
 pathway
In-Reply-To: <20070704145818.GA7784@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0707041152350.25704-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Matthew Garrett wrote:

> On Wed, Jul 04, 2007 at 10:38:47AM -0400, Alan Stern wrote:
> 
> > Okay, I agree that (1) can be handled without too much effort.  But 
> > doing it adds an extra test to _every_ driver's I/O pathway.  Freezing 
> > userspace does not incur all this additional overhead.
> 
> For runtime PM to work it's already necessary to have a test in that 
> path to check if the device is suspended. I can't see how this adds any 
> overhead to the common case.

Actually it isn't necessary to have a test to check if the device is 
suspended.  We simply call the autoresume routine; if the device isn't 
suspended that routine doesn't have to do anything.

I agree that that the extra test (for system-wide suspend underway) is
needed only if the autoresume fails, which isn't part of the main
pathway.  So it doesn't add runtime overhead -- but handling it does
add code overhead.

Alan Stern

