Return-Path: <linux-kernel-owner+w=401wt.eu-S1756639AbYH0TQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639AbYH0TQ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYH0TQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:16:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54664 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752425AbYH0TQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:16:19 -0400
Date: Wed, 27 Aug 2008 15:16:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <greg@kroah.com>, USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round
 2
In-Reply-To: <200808272105.50169.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0808271513270.2138-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Oliver Neukum wrote:

> Am Mittwoch 27 August 2008 20:58:08 schrieb Alan Stern:
> > > And this rule depends on sharing the USB major or not. This needs
> > > a big fat mention in Documentation.
> > 
> > You mean that the open/disconnect locking rule applies only to drivers 
> > that call usb_register_dev, i.e, drivers using the USB major.  Right?
> 
> Yes. In fact drivers not using the USB major but their own char devices
> will need such a lock. This is tricky.

IMO all char-device registration/deregistration routines should use a 
similar rwsem.  Then device drivers wouldn't need to worry about it.

> > I agree that it deserves to be mentioned in the documentation 
> > somewhere.  Where would be a good place?  None of the existing files in 
> > Documentation/usb seem appropriate.
> 
> The USB major merits a file of its own.

I don't feel competent to start writing such a file.  Greg, what do you 
think?  Maybe all that's needed to get going is to "borrow" some of the 
material in LDD3.  :-)

Alan Stern

