Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbZHFWdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbZHFWdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 18:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754687AbZHFWdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 18:33:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46120 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbZHFWdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 18:33:12 -0400
Date: Thu, 6 Aug 2009 15:29:06 -0700
From: Greg KH <gregkh@suse.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Roland Dreier <rdreier@cisco.com>, Matt Fleming <matt@console-pimps.org>,
       David Kiliani <mail@davidkiliani.de>, linux-kernel@vger.kernel.org
Subject: Re: drivers/staging/meilhaus build broken with ftrace
Message-ID: <20090806222906.GA14792@suse.de>
References: <ada4oskfwtp.fsf@cisco.com>
 <alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908061745430.2840@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 05:46:57PM -0400, Steven Rostedt wrote:
> 
> Hi Roland,
> 
> On Thu, 6 Aug 2009, Roland Dreier wrote:
> 
> > Commit fc4c7355 ("ftrace: Fix the conditional that updates $ref_func")
> > breaks the build of drivers/staging/meilhaus with ftrace enabled:
> > 
> >       CC [M]  drivers/staging/meilhaus/me0600_device.o
> >     No function to reference at scripts/recordmcount.pl line 339, <IN> line 258.
> >     make[4]: *** [drivers/staging/meilhaus/me0600_device.o] Error 9
> > 
> > Yes, that's crazy, but the situation is the following:
> > 
> >  - for some reason I can't fathom, the meilhaus driver declares
> >    me0600_pci_constructor() as weak in drivers/staging/meilhaus/me0600_device.h
> > 
> >  - me0600_pci_constructor() is the only function in .text in
> >    drivers/staging/meilhaus/me0600_device.c
> > 
> > so recordmcount.pl ends up finding only one weak function in .text, and
> > so it never sets $ref_func before calling update_funcs().
> 
> Ug, I figured this would happen. I think I have a patch somewhere that can
> handle this.

Don't make ftrace do a lot of work if it's a bug in the staging driver.
Odds are the code in there should be fixed instead, I'll gladly take a
patch to do that.

thanks,

greg k-h
