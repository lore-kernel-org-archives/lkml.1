Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYH0QGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYH0QGr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 12:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYH0QG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 12:06:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50747 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755387AbYH0QGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 12:06:24 -0400
Date: Wed, 27 Aug 2008 12:06:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: add USB test and measurement class driver
In-Reply-To: <200808271008.25779.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0808271203150.2498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008, Oliver Neukum wrote:

> This is a race condition.
> 
> CPU A					CPU B
> open()
> usb_find_interface()
> 						disconnect()
> 						kref_put()
> 						usbtmc_delete()
> 						kfree()
> kref_get()
> 
> You can write to free memory. You must use a static mutex for
> mutual exclusion between open() and disconnect()

Is that necessary?  usbcore includes its own mutual exclusion now.  
Look in file.c at how minor_rwsem is used.

Alan Stern

