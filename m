Return-Path: <linux-kernel-owner+w=401wt.eu-S1753444AbZFOXV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbZFOXV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 19:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZFOXVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 19:21:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46467 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbZFOXVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 19:21:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] PM: Introduce core framework for run-time PM of I/O devices
Date: Tue, 16 Jun 2009 01:21:39 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Magnus Damm <damm@igel.co.jp>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906151700570.2643-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906151700570.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906160121.40843.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 June 2009, Alan Stern wrote:
> On Mon, 15 Jun 2009, Rafael J. Wysocki wrote:
> 
> > On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > > On Sunday 14 June 2009, Rafael J. Wysocki wrote:
> > > > Hi,
> > > > 
> > > > Below is the current version of my "run-time PM for I/O devices" patch.
> > > > 
> > > > I've done my best to address the comments received during the recent
> > > > discussions, but at the same time I've tried to make the patch only contain
> > > > the most essential things.  For this reason, for example, the sysfs interface
> > > > is not there and it's going to be added in a separate patch.
> > > > 
> > > > Please let me know if you want me to change anything in this patch or to add
> > > > anything new to it.  [Magnus, I remember you wanted something like
> > > > ->runtime_wakeup() along with ->runtime_idle(), but I'm not sure it's really
> > > > necessary.  Please let me know if you have any particular usage scenario for
> > > > it.]
> > 
> > Appended is an update of the patch addressing the today's comments from Magnus.
> 
> This is really looking very good.  I'll do a more detailed review
> later.  (In particular, I have not checked the details of the rather
> intricate state machine transitions.)  For now, a couple of things 
> struck my eye:
> 
> Shouldn't the calls to complete() really be complete_all()?  There
> might be more than one thread waiting for a suspend or resume callback
> to finish.

Yes, thanks for pointing that out.

> Since pm_runtime_resume() takes care of powering up the parent, there's 
> no need for pm_request_resume() to worry about it also.

But still it won't hurt to do it IMO, because the parents are then going to be
resumed before our pm_runtime_resume() is called.

> The documentation should mention that the runtime_suspend method is 
> supposed to enable remote wakeup if it as available and if 
> device_may_wakeup(dev) is true.

Well, I thought that was obvious. :-)

Best,
Rafael
