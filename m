Return-Path: <linux-kernel-owner+w=401wt.eu-S1767500AbXCIUsL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767500AbXCIUsL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:48:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767501AbXCIUsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:48:11 -0500
Received: from ns2.suse.de ([195.135.220.15]:46322 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767500AbXCIUsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:48:10 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Fri, 9 Mar 2007 21:48:07 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703091451140.5094-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703091451140.5094-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703092148.08910.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. März 2007 21:08 schrieb Alan Stern:
> After some more thought, I basically agree with what Oliver wrote
> originally.  sysfs_dirent is indeed the logical place to store the kref
> pointer.  However it needs to be used during open and release, not during

OK.

> read, write, and poll.  Another point, which Oliver didn't think of, is
> that the kref pointer needs to be passed to the driver as an argument in
> the show() and store() method calls.

Why? What's wrong with simply calling kref_get/put?
 
> Finally, there's added complexity in each driver which wants to use the 
> new facility.  The module_exit routine will need to be smart enough to 
> block until all the private data structures have been released.  
> usb-storage does something like that now; it's kind of ugly (although it 
> could be improved if appropriate support were added to the core kernel).

If we up the module count for every bound device, all device attributes
should be gone before we ever get that far.

	Regards
		Oliver
