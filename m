Return-Path: <linux-kernel-owner+w=401wt.eu-S1760859AbXGCP6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760859AbXGCP6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbXGCP6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:58:41 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43984 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756215AbXGCP6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:58:40 -0400
Date: Tue, 3 Jul 2007 11:58:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Mackerras <paulus@samba.org>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <linux-pm@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
 RAM pathway
In-Reply-To: <18058.12724.163599.707035@cargo.ozlabs.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0707031146300.3936-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2007, Paul Mackerras wrote:

> Going back to the old powerbook sleep code, we had a two-phase
> suspend: drivers got notified once when userspace is still running,
> with interrupts enabled, in process context; and then a second time
> with interrupts disabled and with only one CPU up, so the process
> that is initiating the suspend is the only process running (since
> interrupts are disabled and nothing it does can sleep, no other
> process can get to run).
> 
> I still believe that is the right way to go, although we currently
> only have a single-phase suspend.
> 
> Most drivers suspended their hardware in the second call.  If they are
> in the middle of a conversation with their device that *has* to be
> completed, they can do that by polling.

Ugh.  That will cause problems when you try to integrate runtime 
suspend.  In fact this whole approach is unsuitable for runtime PM and 
it obscures the similarities between runtime PM and STR.

>  If it's a character device, a
> better approach would be to set a flag or whatever in the first
> suspend call to make sure that no new conversations get started with
> the device, sleeping if necessary.
> 
> I'm actually having a hard time thinking of how to test your assertion
> since there are so few things on a typical computer that are plain
> character devices driving real hardware.  A serial port would be about
> the only one; keyboards and mice (and serial ports :) are USB these
> days, or ADB on older powerbooks.

You don't have to restrict yourself to character devices driving real 
hardware.  The same issues apply to USB and other buses.

Alan Stern

