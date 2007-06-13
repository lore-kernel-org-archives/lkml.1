Return-Path: <linux-kernel-owner+w=401wt.eu-S1758605AbXFMP0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758605AbXFMP0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 11:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757625AbXFMP0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 11:26:09 -0400
Received: from ns1.suse.de ([195.135.220.2]:60695 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757140AbXFMP0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 11:26:09 -0400
Date: Wed, 13 Jun 2007 17:26:00 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Chris Friesen <cfriesen@nortel.com>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>,
       John Sigler <linux.kernel@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: Runaway process and oom-killer
Message-ID: <20070613152600.GH7443@v2.random>
References: <466FAF99.3070708@free.fr> <20070613090837.GD7443@v2.random> <466FB6E8.8020606@free.fr> <466FF154.7030905@aitel.hist.no> <467008E9.7070902@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467008E9.7070902@nortel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2007 at 09:10:33AM -0600, Chris Friesen wrote:
> Helge Hafting wrote:
> 
> >My guess:
> >Something needs memory but finds there is none to be had
> >oom-killer is invoked and targets myapp.
> >myapp takes some time to die. Particularly, the memory it uses
> >isn't freed up instantly.
> 
> Has anyone considered actually bumping up the priority of the task being 
> killed so that it gets to run and free up its resources in a timely manner?
> 
> We've done some experimenting with actually putting it in SCHED_RR and 
> it seems to help (in the case of other busy SCHED_RR tasks on the 
> system).  Admittedly we have an older kernel, so behaviour may be 
> different now.

Replacing the timeslice boost with sched-rr would probably be an ok
cleanup, but I'm unsure if it risks to break the other RT tasks
(especially when folks misuse a soft-RT design to do hard-RT work,
with userland drivers running with RT privilege mapping iommu
regions).

Most cpus goes idle as soon as the oom killer is entered so it
probably doesn't make much difference anyway. I didn't remove the
timeslice hack just because there wasn't any compelling reason to
remove it but it's probably not making much difference.
