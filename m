Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZIQP4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZIQP4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbZIQP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:56:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43315 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755617AbZIQP4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:56:15 -0400
Date: Thu, 17 Sep 2009 16:57:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Amit Shah <amit.shah@redhat.com>
Cc: Markus Armbruster <armbru@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, greg@kroah.com
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for
 generic guest and host communication
Message-ID: <20090917165701.400ad28c@lxorguk.ukuu.org.uk>
In-Reply-To: <20090917134125.GA27511@amit-x200.redhat.com>
References: <1252678386-17404-2-git-send-email-amit.shah@redhat.com>
	<20090911170010.34c80f2d@linux.intel.com>
	<20090911163806.GB25535@amit-x200.redhat.com>
	<4AAA8838.1080106@codemonkey.ws>
	<20090911173307.GB27046@amit-x200.redhat.com>
	<4AAA8A56.3040707@codemonkey.ws>
	<20090916112332.6bf981a5@linux.intel.com>
	<4AB164A0.8000402@codemonkey.ws>
	<87tyz1en5f.fsf@pike.pond.sub.org>
	<20090917141531.4d2489d4@lxorguk.ukuu.org.uk>
	<20090917134125.GA27511@amit-x200.redhat.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan, I'm not sure how many ports at a time people would want to use so
> allocating one major device for this seems OK?

We have very large minor number ranges now so one dynamic major should do
you for a while yet. Probably forever but thats always asking for a
"640K.." moment ;)


> +static ssize_t fill_readbuf(struct virtio_console_port *port,
> +			    char *out_buf, size_t out_count, bool to_user)
> +{

Save yourself serious grief - and the FIXME pain noted below - unless you
are shipping huge objects use a bounce buffer and kill off the to_user
stuff - modern CPUs are so fast doing cache transfers it really isn't
worth the suffering for small stuff.

> +			ret = copy_to_user(out_buf + out_offset,
> +					   buf->buf + buf->offset,
> +					   copy_size);
> +			/* FIXME: Deal with ret != 0 */
