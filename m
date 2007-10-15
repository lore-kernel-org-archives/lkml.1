Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXJOE0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXJOE0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXJOE0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:26:05 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37785 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750775AbXJOE0E (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:26:04 -0400
Date: Mon, 15 Oct 2007 14:25:46 +1000
From: David Chinner <dgc@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: David Chinner <dgc@sgi.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       Morten =?iso-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
Message-ID: <20071015042546.GI995458@sgi.com>
References: <470FA7C3.90404@goop.org> <200710151415.07248.nickpiggin@yahoo.com.au> <4712BB05.1020701@goop.org> <200710151726.08387.nickpiggin@yahoo.com.au> <4712E1AA.501@goop.org> <20071015041133.GH995458@sgi.com> <4712EA09.6000102@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4712EA09.6000102@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2007 at 09:18:17PM -0700, Jeremy Fitzhardinge wrote:
> David Chinner wrote:
> > With defaults - little effect as vmap should never be used. It's
> > only when you start using larger block sizes for metadata that this
> > becomes an issue. The CONFIG_XEN workaround should be fine until we
> > get a proper vmap cache....
> 
> Hm, well I saw the problem with a filesystem made with mkfs.xfs with no
> options, so there must be at least *some* vmapping going on there.

Sorry - I should have been more precise - vmap should never be used in
performance critical paths on default configs.  Log recovery will
trigger vmap/vunmap usage, so this is probably what you are seeing.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
