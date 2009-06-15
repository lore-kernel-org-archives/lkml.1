Return-Path: <linux-kernel-owner+w=401wt.eu-S934531AbZFOVJR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531AbZFOVJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:09:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934487AbZFOVI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:08:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54296 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934479AbZFOVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:08:56 -0400
Date: Mon, 15 Jun 2009 17:08:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <damm@igel.co.jp>,
       <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of
 I/O devices
In-Reply-To: <200906150057.32424.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906151700570.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009, Rafael J. Wysocki wrote:

> On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > Below is the current version of my "run-time PM for I/O devices" patch.
> > > 
> > > I've done my best to address the comments received during the recent
> > > discussions, but at the same time I've tried to make the patch only contain
> > > the most essential things.  For this reason, for example, the sysfs interface
> > > is not there and it's going to be added in a separate patch.
> > > 
> > > Please let me know if you want me to change anything in this patch or to add
> > > anything new to it.  [Magnus, I remember you wanted something like
> > > ->runtime_wakeup() along with ->runtime_idle(), but I'm not sure it's really
> > > necessary.  Please let me know if you have any particular usage scenario for
> > > it.]
> 
> Appended is an update of the patch addressing the today's comments from Magnus.

This is really looking very good.  I'll do a more detailed review
later.  (In particular, I have not checked the details of the rather
intricate state machine transitions.)  For now, a couple of things 
struck my eye:

Shouldn't the calls to complete() really be complete_all()?  There
might be more than one thread waiting for a suspend or resume callback
to finish.

Since pm_runtime_resume() takes care of powering up the parent, there's 
no need for pm_request_resume() to worry about it also.

The documentation should mention that the runtime_suspend method is 
supposed to enable remote wakeup if it as available and if 
device_may_wakeup(dev) is true.

Alan Stern

