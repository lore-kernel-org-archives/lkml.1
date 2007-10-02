Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbXJBHit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbXJBHit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 03:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbXJBHi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 03:38:29 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49752 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756017AbXJBHi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 03:38:27 -0400
Date: Tue, 2 Oct 2007 17:38:09 +1000
From: David Chinner <dgc@sgi.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       byron.bbradley@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: XFS Fails Quality Assurance Tests on ARM
Message-ID: <20071002073809.GA995458@sgi.com>
References: <fb80ve$i5q$1@sea.gmane.org> <20070830.213901.48806818.davem@davemloft.net> <p73ps12vxrl.fsf@bingen.suse.de> <200709280740.48723.nickpiggin@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709280740.48723.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2007 at 07:40:48AM +1000, Nick Piggin wrote:
> On Sunday 02 September 2007 08:14, Andi Kleen wrote:
> > David Miller <davem@davemloft.net> writes:
> > > From: Byron Bradley <byron.bbradley@gmail.com>
> > > Date: Fri, 31 Aug 2007 03:12:46 +0000 (UTC)
> > > > Anybody got any ideas of how we fix this?
> > >
> > > I don't know how much testing XFS gets on ARM, but one thing that some
> > > ARM chips have is D-cache aliasing problems and one thing XFS uses a
> > > lot is virtual remapping of various data structures via vmap().
> > >
> > > This might be what is causing the problems.
> >
> > AFAIK XFS uses vmap() mainly during log replay. If David's theory
> > was true then the failures must be seen during tests that do
> > this.
> 
> I think it can also do vmap for directory lookups, and it crashed
> in some directory lookup AFAIKS.
> 
> One way to verify would be to create the XFS filesystem with PAGE_SIZE
> directory blocks (mkfs.xfs -nsize=PAGE_SIZE) I believe. Dave will correct
> me if I'm wrong.

By default the directory block size is the same as the filesystem
block size which means it will be <= PAGE_SIZE unless some
special mkfs.xfs goo was used. What is the output of 'xfs_info <mntpt>'
on the machine in question?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
