Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbZDFT6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbZDFT6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754804AbZDFT6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:58:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49446 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbZDFT6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:58:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [linux-pm] pm-hibernate : possible circular locking dependency detected
Date: Mon, 6 Apr 2009 21:58:10 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-rjw; KDE/4.2.2; x86_64; ; )
Cc: Gautham R Shenoy <ego@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.0904061439230.4571-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0904061439230.4571-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904062158.11245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 April 2009, Alan Stern wrote:
> On Mon, 6 Apr 2009, Gautham R Shenoy wrote:
> 
> > > If I understand correctly it isn't really a deadlock scenario, but it
> > > is a lockdep violation.  The violation is:
> > > 
> > > 	The pci_device_probe() path 2) proves that dpm_list_mtx [4] can
> > > 	be acquired while cpu_hotplug.lock [3] is held;
> > > 
> > > 	The hibernate() path 3) proves that cpu_hotplug.lock [3] can be
> > > 	acquired while dpm_list_mtx [4] is held.
> > > 
> > > The two pathways cannot run simultaneously (and hence cannot deadlock) 
> > > because the prepare() stage of hibernation is supposed to stop all 
> > > device probing.  But lockdep will still report a problem.
> > 
> > Thanks for clarifying this Alan. I guess it boils down to teaching
> > lockdep about this false-positive.
> 
> Or else changing the code somehow to avoid the violation completely.  
> But I have no idea how...  And AFAIK, teaching lockdep about special 
> cases like this is not so easy to do.

Yeah, I've just wanted to ask about that.  Peter, how can we do it?

Rafael
