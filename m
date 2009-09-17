Return-Path: <linux-kernel-owner+w=401wt.eu-S1758150AbZIQQLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758150AbZIQQLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755916AbZIQQLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:11:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43437 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbZIQQLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:11:12 -0400
Date: Thu, 17 Sep 2009 12:11:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       drbd-dev@lists.linbit.com, Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Kyle Moffett <kyle@moffetthome.net>, Lars Marowsky-Bree <lmb@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Brown <neilb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [GIT PULL] DRBD for 2.6.32
Message-ID: <20090917161108.GA3361@infradead.org>
References: <200909151645.14256.philipp.reisner@linbit.com> <20090915231931.GB7636@infradead.org> <20090917081251.GC8045@barkeeper1-xen.linbit> <1253203365.7845.14.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253203365.7845.14.camel@mulgrave.site>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:02:45AM -0600, James Bottomley wrote:
> So I think Christoph's NAK is rooted in the fact that we have a
> proliferation of in-kernel RAID implementations and he's trying to
> reunify them all again.
> 
> As part of the review, reusing the kernel RAID (and actually logging)
> logic did come up and you added it to your todo list.  Perhaps expanding
> on the status of that would help, since what's being looked for is that
> you're not adding more work to the RAID reunification effort and that
> you do have a plan and preferably a time frame for coming into sync with
> it.

Yes.  RDBD has spend tons of time out of tree, and if they want to put
it in now I think requiring them to do their homework is a good idea.

Note that the in-kernel raid implementation is just a rather small part
of this, what's much more important is the user interface.  A big part
of raid unification is that we can support on proper interface to deal
with raid vs volume management, and DRBD adds another totally
incompatible one to that.  We'd be much better off adding the drbd in
the write protocol (at least the most recent version) to DM instead of
adding another big chunk of framework.

