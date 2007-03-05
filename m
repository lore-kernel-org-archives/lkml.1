Return-Path: <linux-kernel-owner+w=401wt.eu-S965681AbXCENgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965681AbXCENgt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 08:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965676AbXCENgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 08:36:49 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32846 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965681AbXCENgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 08:36:48 -0500
Date: Mon, 5 Mar 2007 13:36:39 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
Message-ID: <20070305133639.GA6490@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Roland McGrath <roland@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0703021158001.2485-100000@iolanthe.rowland.org> <20070305070136.4CB881801C4@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305070136.4CB881801C4@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 04, 2007 at 11:01:36PM -0800, Roland McGrath wrote:
> > 	The parts relating to kernel breakpoints could be made conditional
> > 	on a Kconfig option.  The amount of code space saved would be
> > 	relatively small; I'm not sure that it would be worthwhile.
> 
> In a utrace merge, the user parts can be made conditional on CONFIG_UTRACE.
> Then with both turned off, the code goes away completely.  It's unlikely it
> will ever be turned off, but it is a clean way to go about things in case
> someone wants the smallest possible config for a limited-use installation.

Making this unconditional is pointless and just makes things harder to
read, so please don't do it.  (The same is true for utrace, but Roland
has unfortunately still not replied to my mail mentioning it :P)

> > +	void		(*installed)(struct hwbkpt *);
> > +	void		(*uninstalled)(struct hwbkpt *);
> 
> Save space in the struct by having just one function for both installed
> and uninstalled, taking an argument.  Probably a caller should be able to
> pass a null function here to say that the registration call should fail if
> it can't be installed due to higher-priority or no-callback registrations
> existing, and that its registration cannot be ejected by another (i.e., an
> ill-behaved user).

Please not.  That might save a few bytes, but it makes the interface a
lot harder to understand for users.  We really discourage over-loaded
interfaces in Linux.

> > +struct thread_hwbkpt {		/* HW breakpoint info for a thread */

Can this and all the file names please get an actually readable name?
E.g. hw_breakpoint.  We're not IBM managers that needs to save every
cent on superflous sillables :)

