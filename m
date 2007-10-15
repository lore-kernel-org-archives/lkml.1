Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbXJOEMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbXJOEMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750919AbXJOELw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:11:52 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42870 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750864AbXJOELv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:11:51 -0400
Date: Mon, 15 Oct 2007 14:11:33 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071015041133.GH995458@sgi.com>
References: <470FA7C3.90404@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <4712BB05.1020701@goop.org> <200710151726.08387.nickpiggin@yahoo.com.au> <4712E1AA.501@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4712E1AA.501@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 08:42:34PM -0700, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> >  That's not going to
> > happen for at least a cycle or two though, so in the meantime maybe
> > an ifdef for that XFS vmap batching code would help?
> >   
> 
> For now I've proposed a patch to simply eagerly vunmap everything when
> CONFIG_XEN is set.  It certainly works, but I don't have a good feel for
> how much of a performance hit that imposes on XFS.

With defaults - little effect as vmap should never be used. It's
only when you start using larger block sizes for metadata that this
becomes an issue. The CONFIG_XEN workaround should be fine until we
get a proper vmap cache....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
