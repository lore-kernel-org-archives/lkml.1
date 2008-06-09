Return-Path: <linux-kernel-owner+w=401wt.eu-S1759543AbYFIPDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759543AbYFIPDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYFIPDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:03:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48682 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753145AbYFIPDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:03:11 -0400
Date: Mon, 9 Jun 2008 11:03:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pavel Machek <pavel@suse.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linus Torvalds <torvalds@linuxfoundation.org>, <gregkh@suse.de>,
       Andrew Morton <akpm@linuxfoundation.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc6: CONFIG_USB_PERSIST forced on
In-Reply-To: <20080609080052.GA27899@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0806091100060.2943-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008, Pavel Machek wrote:

> Besides, it seems to break suspend/resume of printers, and probably
> all the drivers that do not have reset_resume() method. That's
> actually a regression.
> 
> https://bugzilla.novell.com/show_bug.cgi?id=394820

The right way to fix this is to add reset_resume to the printer driver.  

More generally, usbcore should be changed so that drivers which don't 
support reset_resume get unbound from their devices when a reset-resume 
occurs.  I wrote something to do that last year, but with all the 
changes going on in the driver core it is now obsolete.

Alan Stern

