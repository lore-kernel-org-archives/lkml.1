Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZIQIMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZIQIMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 04:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZIQIMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 04:12:53 -0400
Received: from mail09.linbit.com ([212.69.161.110]:38964 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbZIQIMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 04:12:49 -0400
Date: Thu, 17 Sep 2009 10:12:51 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
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
Message-ID: <20090917081251.GC8045@barkeeper1-xen.linbit>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, drbd-dev@lists.linbit.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Bart Van Assche <bart.vanassche@gmail.com>,
	Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Jens Axboe <jens.axboe@oracle.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Kyle Moffett <kyle@moffetthome.net>,
	Lars Marowsky-Bree <lmb@suse.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Neil Brown <neilb@suse.de>,
	"Nicholas A. Bellinger" <nab@linux-iscsi.org>,
	Nikanth Karthikesan <knikanth@suse.de>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Sam Ravnborg <sam@ravnborg.org>
References: <200909151645.14256.philipp.reisner@linbit.com> <20090915231931.GB7636@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090915231931.GB7636@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I took the liberty to extend the CC list again a little bit.

On Tue, Sep 15, 2009 at 07:19:31PM -0400, Christoph Hellwig wrote:
> On Tue, Sep 15, 2009 at 04:45:13PM +0200, Philipp Reisner wrote:
> > Hi Linus,
> > 
> > Please pull
> > git://git.drbd.org/linux-2.6-drbd.git drbd
> > 
> > DRBD is a shared-nothing, replicated block device. It is designed to
> > serve as a building block for high availability clusters and
> > in this context, is a "drop-in" replacement for shared storage.
> > 
> > It has been discussed and reviewed on the list since March,
> > and Andrew has asked us to send a pull request for 2.6.32-rc1.


This has been discussed before on LKML.

To contrast your NACK by a few previous posts
I perceived effectively as ACKS:
e.g.

Andrew Morton:
http://lkml.org/lkml/2009/5/1/307

	"Oh.  Thanks.  Well we should all get cracking on it then."

Lars Marowsky-Bree:
http://lkml.org/lkml/2009/5/5/224

	"I would suggest at this time, we may want to refocus on the remaining
	objections to merging drbd as a driver in the short-term."

In reply to that,

	James Bottomley:
	http://lkml.org/lkml/2009/5/5/226

		"I'd agree with that.  drbd essentially qualifies as a
		driver under our new merge rules, so we should be
		thinking about blockers to getting it into the tree
		first (serious issues) and working out kinks
		(like raid unification) after it gets in."

	Neil Brown:
	http://lkml.org/lkml/2009/5/5/332

		"I cannot imagine that there would be any. Given its
		history, its popularity, and its modularity, there can
		be no question about merging it"

hch:
> 
> The last thing we need is another bloody raid-reimplementation,

It is not RAID, it is replication, see also that blog post below.

> coupled with a propritary on the wire protocol.

http://www.openformats.org/en1
proprietary:
"the mode of presentation of its data is opaque
 and its specification is not publicly available"

Which does not apply to DRBD.

So lets settle for "homegrown".

Besides, what was the non-proprietary, generally accepted,
link layer agnostic block-level replication protocol again?

And in case you're referring to MD/NBD or MD/iSCSI or some such,
http://fghaas.wordpress.com/2009/09/16/alternatives-to-drbd/ may be a
worthy read. Certainly not deeply technical, but sufficient to
illustrate the most important points.

> NACK as far as I am concerned.

Too bad :(
What can we do to have that revised?


-- 
: Lars Ellenberg
: LINBIT | Your Way to High Availability
: DRBD/HA support and consulting http://www.linbit.com

DRBD® and LINBIT® are registered trademarks of LINBIT, Austria.
