Return-Path: <linux-kernel-owner+w=401wt.eu-S1755588AbYHMQX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588AbYHMQX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 12:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYHMQXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 12:23:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60759 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752178AbYHMQXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 12:23:49 -0400
Date: Wed, 13 Aug 2008 12:23:48 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Oliver Neukum <oneukum@suse.de>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       <James.Bottomley@hansenpartnership.com>, <teheo@novell.com>
Subject: Re: Power management for SCSI
In-Reply-To: <48A30864.2030106@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.0808131222570.2308-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008, Stefan Richter wrote:

> > For transports which are like USB, we should do autosuspend at the
> > target (not device) level.  This means invoking the suspend/resume 
> > routines of the ULDs like sd and sr.  The transport gets notified when 
> > all of the targets are suspended.  (Or maybe the host driver gets 
> > notified instead; there probably isn't any advantage to using the 
> > transport class here.)
> > 
> > For other transports, we should only do idle-timeout detection.  The
> > transport gets notified when any target has been idle for sufficiently 
> > long, so that it can power down the link.  The ULDs are not involved.
> > 
> > Does that sound okay?
> 
> Minor correction:  The ULD suspend/resume methods necessarily work on
> logical units, not targets.

Yes; I should said that the suspend/resume methods of the ULD for each 
of the target's LUNs gets invoked.

Alan Stern

