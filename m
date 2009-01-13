Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbZANADF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbZANADF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 19:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbZANACw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 19:02:52 -0500
Received: from ns1.suse.de ([195.135.220.2]:40675 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421AbZANACv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 19:02:51 -0500
Date: Tue, 13 Jan 2009 15:59:14 -0800
From: Greg KH <gregkh@suse.de>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Miller <davem@davemloft.net>, Jesper.Nilsson@axis.com, tj@kernel.org,
       stern@rowland.harvard.edu, jens.axboe@oracle.com,
       hinko.kocevar@cetrtapot.si, linux-kernel@vger.kernel.org
Subject: Re: lib/klist.c: bit 0 in pointer can't be used as flag
Message-ID: <20090113235914.GA20727@suse.de>
References: <2f11576a0901131440w7fd3290uc9664aaf7aa89b08@mail.gmail.com> <20090113.144521.97357573.davem@davemloft.net> <20090114085341.442C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114085341.442C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 08:54:20AM +0900, KOSAKI Motohiro wrote:
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > Date: Wed, 14 Jan 2009 07:40:19 +0900
> > 
> > > > It may be that we've worked around the other spots, although I haven't
> > > > seen anything like that, we might just have been lucky until now.
> > > >
> > > > Can you recall another place where this trick is used?
> > > 
> > > rmap.
> > > Don't CRIS use mmu?
> > 
> > I'm beginning to suspect the issue is only with objects
> > in the kernel image itself.  Dynamically allocated memory
> > is properly aligned and therefore the "low bit status bits
> > in pointer" trick works.
> 
> Ah, I see.
> very thank you for helpful explain.

So, is this change still needed for klists?  I'm guessing so as they
could be in statically allocated objects, right?

Here's yet another reason to never statically allocate a kobject...

thanks,

greg k-h
