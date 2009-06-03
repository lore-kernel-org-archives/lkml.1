Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbZFCIJL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbZFCIJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:09:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756776AbZFCII5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:08:57 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36477 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041AbZFCII4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:08:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] usb: avoid PM error messages during resume if a device was disconnected
Date: Wed, 3 Jun 2009 10:08:52 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Frans Pop <elendil@planet.nl>, linux-usb@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0906022056070.8257-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906022056070.8257-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906031008.53326.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 June 2009, Alan Stern wrote:
> On Wed, 3 Jun 2009, Rafael J. Wysocki wrote:
> 
> > > +	/* Avoid PM error messages for devices disconnected while suspended
> > > +	 * as we'll display regular disconnect messages just a bit later.
> > > +	 */
> > > +	if (status == -ENODEV)
> > > +		return 0;
> > > +	return status;
> > 
> > + return status == -ENODEV ? 0 : status;
> > 
> > maybe?
> > 
> > >  }
> > >  
> > >  #endif /* CONFIG_PM */
> 
> Personally, I would do:
> 
> 	if (status == -ENODEV)
> 		status = 0;
> 	return status;
> 
> It doesn't make any difference; they are all equally good.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

OK

Am I supposed to take this patch directly or push it to Greg?

Rafael
