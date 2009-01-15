Return-Path: <linux-kernel-owner+w=401wt.eu-S1760445AbZAOJWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760445AbZAOJWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZAOJWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:22:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:60163 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971AbZAOJWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:22:21 -0500
Date: Thu, 15 Jan 2009 09:23:52 +0000
From: Arjan van de Ven <arjan@infradead.org>
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, pavel@suse.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] resume: wait for device probing to finish
Message-ID: <20090115092352.5d2ceffd@infradead.org>
In-Reply-To: <1231983276.7229.575.camel@nigel-laptop>
References: <200901142303.46166.rjw@sisk.pl>
	<20090114152444.64e1ddfb.akpm@linux-foundation.org>
	<200901150039.58972.rjw@sisk.pl>
	<1231983276.7229.575.camel@nigel-laptop>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 12:34:36 +1100
Nigel Cunningham <ncunningham@crca.org.au> wrote:

> Hi Rafael etc.
> 
> On Thu, 2009-01-15 at 00:39 +0100, Rafael J. Wysocki wrote:
> 
> [...]
>  
> >  /**
> > + * wait_for_device_probe
> > + * Wait for device probing to be completed.
> > + *
> > + * Note: this function polls at 100 msec intervals.
> > + */
> > +int wait_for_device_probe(void)
> > +{
> > +	/* wait for the known devices to complete their probing */
> > +	while (driver_probe_done() != 0)
> > +		msleep(100);
> > +	async_synchronize_full();
> > +	return 0;
> > +}
> > +
> 
> Am I missing something? I can't see why you're polling instead of
> using probe_waitqueue.

I'm just consolidating the existing code to one place.

