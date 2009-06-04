Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZFDVnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZFDVnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZFDVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:43:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:64725 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbZFDVnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bkjiZdVNJd2dhLPjYg4ZxNKyQnfs25A02wRJarxKBjZ+khhPPbhRwAmHu4xN1UqJf8
         ql5pcgNzyPaUISwg7AbyPEOkkrGvVZb+ccTVykge4GoU40sC4W73VDBtz+xQsTB94PKO
         6wDlz9bhuDdqvN+vb8Acq0V4d2PO6JkebGSPY=
Date: Thu, 4 Jun 2009 23:37:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, tytso@mit.edu, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v9
Message-ID: <20090604213704.GC4862@nowhere>
References: <1243511204-2328-1-git-send-email-jens.axboe@oracle.com> <20090604152040.GA6007@nowhere> <20090604120726.708a2211.akpm@linux-foundation.org> <20090604191309.GA4862@nowhere> <20090604195013.GB11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604195013.GB11363@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 09:50:13PM +0200, Jens Axboe wrote:
> On Thu, Jun 04 2009, Frederic Weisbecker wrote:
> > On Thu, Jun 04, 2009 at 12:07:26PM -0700, Andrew Morton wrote:
> > > On Thu, 4 Jun 2009 17:20:44 +0200 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > > 
> > > > I've just tested it on UP in a single disk.
> > > 
> > > I must say, I'm stunned at the amount of testing which people are
> > > performing on this patchset.  Normally when someone sends out a
> > > patchset it just sort of lands with a dull thud.
> > > 
> > > I'm not sure what Jens did right to make all this happen, but thanks!
> > 
> > 
> > I don't know how he did either. I was reading theses patches and *something*
> > pushed me to my testbox, and then I tested...
> > 
> > Jens, how do you do that?
> 
> Heh, not sure :-)
> 
> But indeed, thanks for the testing. It looks quite interesting. I'm
> guessing it probably has to do with who ends up doing the balancing and
> that the flusher threads block, it may change the picture a bit. So it
> may just be that it'll require a few vm tweaks. I'll definitely look
> into it and try and reproduce your results.
> 
> Did you run it a 2nd time on each drive and check if the results were
> (approximately) consistent on the two drives?


Another snapshot, only with bdi-writeback this time.

http://kernel.org/pub/linux/kernel/people/frederic/dbench2.pdf

Looks like the same effect but the difference is more quiet this time.

I guess there is a good bunch of entropy inside, so it's hard to tell :)
I'll test with no op scheduler.

