Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZDFSmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZDFSmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 14:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbZDFSm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 14:42:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54547 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752508AbZDFSm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 14:42:28 -0400
Date: Mon, 6 Apr 2009 14:42:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Gautham R Shenoy <ego@in.ibm.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [linux-pm] pm-hibernate : possible circular locking dependency
 detected
In-Reply-To: <20090406152038.GB17559@in.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0904061439230.4571-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Apr 2009, Gautham R Shenoy wrote:

> > If I understand correctly it isn't really a deadlock scenario, but it
> > is a lockdep violation.  The violation is:
> > 
> > 	The pci_device_probe() path 2) proves that dpm_list_mtx [4] can
> > 	be acquired while cpu_hotplug.lock [3] is held;
> > 
> > 	The hibernate() path 3) proves that cpu_hotplug.lock [3] can be
> > 	acquired while dpm_list_mtx [4] is held.
> > 
> > The two pathways cannot run simultaneously (and hence cannot deadlock) 
> > because the prepare() stage of hibernation is supposed to stop all 
> > device probing.  But lockdep will still report a problem.
> 
> Thanks for clarifying this Alan. I guess it boils down to teaching
> lockdep about this false-positive.

Or else changing the code somehow to avoid the violation completely.  
But I have no idea how...  And AFAIK, teaching lockdep about special 
cases like this is not so easy to do.

Alan Stern

