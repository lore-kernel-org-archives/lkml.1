Return-Path: <linux-kernel-owner+w=401wt.eu-S1758717AbZIQQrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717AbZIQQrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 12:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758699AbZIQQrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 12:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41606 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbZIQQrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 12:47:11 -0400
Date: Thu, 17 Sep 2009 22:16:33 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Markus Armbruster <armbru@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
	generic guest and host communication
Message-ID: <20090917164633.GA29951@amit-x200.redhat.com>
References: <20090911163806.GB25535@amit-x200.redhat.com> <4AAA8838.1080106@codemonkey.ws> <20090911173307.GB27046@amit-x200.redhat.com> <4AAA8A56.3040707@codemonkey.ws> <20090916112332.6bf981a5@linux.intel.com> <4AB164A0.8000402@codemonkey.ws> <87tyz1en5f.fsf@pike.pond.sub.org> <20090917141531.4d2489d4@lxorguk.ukuu.org.uk> <20090917134125.GA27511@amit-x200.redhat.com> <20090917165701.400ad28c@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917165701.400ad28c@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Thu) Sep 17 2009 [16:57:01], Alan Cox wrote:
> > Alan, I'm not sure how many ports at a time people would want to use so
> > allocating one major device for this seems OK?
> 
> We have very large minor number ranges now so one dynamic major should do
> you for a while yet. Probably forever but thats always asking for a
> "640K.." moment ;)

:-) OK.

> > +static ssize_t fill_readbuf(struct virtio_console_port *port,
> > +			    char *out_buf, size_t out_count, bool to_user)
> > +{
> 
> Save yourself serious grief - and the FIXME pain noted below - unless you
> are shipping huge objects use a bounce buffer and kill off the to_user
> stuff - modern CPUs are so fast doing cache transfers it really isn't
> worth the suffering for small stuff.

I would if I knew what it is that you are suggesting. A bounce buffer
for guest kernel - guest userspace communication?

This is what it looks like right now:

For guest kernel - host communication, I'm using virtio - which is a
bounce buffer (guest allocates pages, host fetches, reads/writes, guest
gets an ack).

But I probably didn't get what you meant, so please explain.

> > +			ret = copy_to_user(out_buf + out_offset,
> > +					   buf->buf + buf->offset,
> > +					   copy_size);
> > +			/* FIXME: Deal with ret != 0 */

		Amit
