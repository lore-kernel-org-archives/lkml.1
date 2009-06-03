Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZFCA5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZFCA5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 20:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbZFCA5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 20:57:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54257 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751024AbZFCA5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 20:57:45 -0400
Date: Tue, 2 Jun 2009 20:57:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, <linux-usb@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: avoid PM error messages during resume if a device
 was disconnected
In-Reply-To: <200906030053.41385.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0906022056070.8257-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Rafael J. Wysocki wrote:

> > +	/* Avoid PM error messages for devices disconnected while suspended
> > +	 * as we'll display regular disconnect messages just a bit later.
> > +	 */
> > +	if (status == -ENODEV)
> > +		return 0;
> > +	return status;
> 
> + return status == -ENODEV ? 0 : status;
> 
> maybe?
> 
> >  }
> >  
> >  #endif /* CONFIG_PM */

Personally, I would do:

	if (status == -ENODEV)
		status = 0;
	return status;

It doesn't make any difference; they are all equally good.

Acked-by: Alan Stern <stern@rowland.harvard.edu>


