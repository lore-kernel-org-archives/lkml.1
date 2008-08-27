Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbYH0RFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbYH0RFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYH0REk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:04:40 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41915 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYH0REj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:04:39 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Date: Wed, 27 Aug 2008 19:05:51 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0808271203150.2498-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808271203150.2498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808271905.51825.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 27 August 2008 18:06:23 schrieb Alan Stern:
> On Wed, 27 Aug 2008, Oliver Neukum wrote:
> 
> > This is a race condition.
> > 
> > CPU A					CPU B
> > open()
> > usb_find_interface()
> > 						disconnect()
> > 						kref_put()
> > 						usbtmc_delete()
> > 						kfree()
> > kref_get()
> > 
> > You can write to free memory. You must use a static mutex for
> > mutual exclusion between open() and disconnect()
> 
> Is that necessary?  usbcore includes its own mutual exclusion now.  
> Look in file.c at how minor_rwsem is used.

This is interesting, the driver simply doesn't  unregister the device.
So it would be needed if the code could be left as it is. As not unregistering
the device is wrong, this will fix the bug.

	Thanks
		Oliver
