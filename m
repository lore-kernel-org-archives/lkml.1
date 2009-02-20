Return-Path: <linux-kernel-owner+w=401wt.eu-S1755897AbZBTIUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbZBTIUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 03:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZBTIUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 03:20:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43677 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751746AbZBTIUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 03:20:20 -0500
Subject: Re: GFS2: Add blktrace support to glocks
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <20090219185919.GB28490@infradead.org>
References: <1235062539.9571.771.camel@quoit>
	 <20090219185919.GB28490@infradead.org>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Fri, 20 Feb 2009 08:16:58 +0000
Message-Id: <1235117818.9571.780.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 2009-02-19 at 13:59 -0500, Christoph Hellwig wrote:
> On Thu, Feb 19, 2009 at 04:55:39PM +0000, Steven Whitehouse wrote:
> > Hi,
> > 
> > Since I last posted this pair of patches, I've done some extensive
> > updating of the kernel patch, so it should now be happy to compile
> > under all possible Kconfigs (fingers crossed) and also its a fair
> > bit cleaner too.
> > 
> > I'm adding the linux-btrace list, since I didn't know about that
> > list when I made the initial posting.
> > 
> > Since there is probably more GFS2 changes than blktrace changes, I
> > could push this through the GFS2 tree. Let me know if you'd prefer
> > it to go via the blktrace tree. I'd like to be able to push this
> > in at the next merge window if possible. This patch is against the
> > head of the GFS2 -nmw git tree (obviously that makes no difference
> > to the blktrace side of the patch).
> > 
> > An updated blktrace userland patch follows in the next email, although
> > the changes from the last version are fairly minor,
> 
> Umm, why would you put fs internal stuff into blktrace?  Just use
> the generic ringbuffer directly and trace into that one.
> 

>From the patch description:

Glocks are the cache control subsystem for GFS2. It is very useful
to be able to trace the state changes of the glocks using the
same set of sequence numbers as the I/O requests, since this
allows us to see if there are any ordering errors.


Maybe there is a way to keep the sequencing between I/O and glocks some
other way, but it looked to me like I would lose that if I were to have
a separate logging system for glocks. So really what I'm saying is that
logging glocks on their own isn't a lot of use, its only useful when
combined with I/O logging,

Steve.


