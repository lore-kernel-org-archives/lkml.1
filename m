Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab0CBRZh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 12:25:37 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50729 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752433Ab0CBRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 12:25:36 -0500
Date: Tue, 2 Mar 2010 17:28:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@linux.intel.com>, jeff@garzik.org.com,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [RFC 1/4] libata: cache device select
Message-ID: <20100302172847.2e87de07@lxorguk.ukuu.org.uk>
In-Reply-To: <4B8C2079.7010607@garzik.org>
References: <20100217130847.16338.55586.stgit@localhost.localdomain>
	<4B8C2079.7010607@garzik.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > -	ata_dev_select(ap, qc->dev->devno, 1, 0);
> > +	if (qc->dev->devno != ap->sff_selected)
> > +        	ata_dev_select(ap, qc->dev->devno, 1, 0);
> >
> >   	/* start the command */
> >   	switch (qc->tf.protocol) {
> 
> My main worry here is that this logic excises the 150ms wait in 
> ata_dev_select() that has been used effectively to allow ATAPI devices 
> to "collect themselves" after waiting for idle, prior to command issuance.

It doesn't. You call it with wait = 1, can_sleep = 0 so it will never do
the 150ms magic delay here anyway (good job or it would kill us for
performance ;))

It does mean we don't do the device idle wait in that situation but there
are no code paths where we try to overlap commands by spinning on the
drive busy bit (again for obvious reasons)

Alan
