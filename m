Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYDVTwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYDVTwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 15:52:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765176AbYDVTvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 15:51:45 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:36742 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765156AbYDVTvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 15:51:44 -0400
Date: Tue, 22 Apr 2008 14:51:42 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       containers@lists.linux-foundation.org, nick@nick-andrew.net,
       Nadia.Derbey@bull.net, linux-kernel@vger.kernel.org
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 -  Object
	creation with a specified id)
Message-ID: <20080422195142.GA22145@sergelap.austin.ibm.com>
References: <20080418054459.891481000@bull.net> <20080422193612.GA15835@martell.zuzino.mipt.ru> <1208890580.17117.14.camel@nimitz.home.sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208890580.17117.14.camel@nimitz.home.sr71.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Tue, 2008-04-22 at 23:36 +0400, Alexey Dobriyan wrote:
> > On Fri, Apr 18, 2008 at 07:44:59AM +0200, Nadia.Derbey@bull.net wrote:
> > >    . echo "LONG XX" > /proc/self/task/<my_tid>/next_id
> > >      next object to be created will have an id set to XX
> > >    . echo "LONG<n> X0 ... X<n-1>" > /proc/self/task/<my_tid>/next_id
> > >      next object to be created will have its ids set to XX0, ... X<n-1>
> > >      This is particularly useful for processes that may have several ids if
> > >      they belong to nested namespaces.
> > 
> > Can we answer the following questions before merging this patch:
> > 
> > a) should mainline kernel have checkpoint/restart feature at all
> > b) if yes, should it be done from kernel- or userspace?
> > 
> > Until agreement will be "yes/from userspace" such patches don't make
> > sense in mainline.
> 
> What do you mean by "from kernel" or "from userspace"?  Userspace has to
> be involved somewhere, right?  It at least need to open() the checkpoint
> file and pass it into the kernel.  		

Well let's start by answering a) :

	I vote yes  :-)

As for b), good question.  Except as Dave points out I think it's pretty
unlikely that we'll end up with "sys_checkpoint(checkpoint_dirnam)"
and "sys_restart(checkpointed_dirnam)".  Anything more user-space
driven will likely require userspace to set ids on resources, right?

But yes, we have to completely answer b) before this patch goes in, no
doubt about that.

Alexey, are you advocating for a completely kernel-driven approach, or
just making sure we come to a decision?

thanks,
-serge
