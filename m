Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYIJOUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYIJOUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 10:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYIJOT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 10:19:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40634 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbYIJOTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:19:55 -0400
Date: Wed, 10 Sep 2008 10:19:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Janne Grunau <j@jannau.net>
Cc: Christoph Hellwig <hch@infradead.org>, Jarod Wilson <jwilson@redhat.com>,
       Ville Syrj?l? <syrjala@sci.fi>, linux-kernel@vger.kernel.org,
       Christoph Bartelmus <lirc@bartelmus.de>
Subject: Re: [PATCH 06/18] lirc driver for the ATI USB RF remote receiver
Message-ID: <20080910141947.GA32564@infradead.org>
References: <1220933164-10160-1-git-send-email-jwilson@redhat.com> <200809100905.58304.jwilson@redhat.com> <20080910131432.GA2161@infradead.org> <200809101544.17704.j@jannau.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809101544.17704.j@jannau.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 03:44:17PM +0200, Janne Grunau wrote:
> On Wednesday 10 September 2008 15:14:32 Christoph Hellwig wrote:
> > On Wed, Sep 10, 2008 at 09:05:58AM -0400, Jarod Wilson wrote:
> > > True, though I think some users still prefer using them with the
> > > lirc drivers for assorted reasons. Configuring something like
> > > mythtv to work with the ati_remote{,2} driver appears to be a bit
> > > more complex (or at least non- standard vs. several other popular
> > > remotes) and not as functional vs. configuring mythtv
> > > w/lirc_atiusb.
> >
> > Bad idea to have two drivers for the same piece of hardware.  And
> > this gets straight back into the why should lirc be different from
> > the input layer point raised earlies.  I think we really shouldn't
> > keep lirc as a separate subsystem, but make sure all the drivers are
> > written to the input layer.
> 
> Some drivers don't report events but deliver the signal to the lirc 
> daemon. The daemon decodes the signal. Decoding of several IR protocols 
> and mapping of each possible remote to events are things much easier 
> done in userspace.

Mixing these two in the same interface seems like a really bad idea.
The input layer is the right interface for devices that directly produce
events.  If you want to decode them in userspace you need a different
interface for the daemon.  Not sure why you really want to do this in
userspace, though.

> Aslo LIRC is not only about IR input but also output.

The input layer also does some outputs, like the pc speaker :)



