Return-Path: <linux-kernel-owner+w=401wt.eu-S965814AbXCIUjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965814AbXCIUjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965812AbXCIUjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:39:46 -0500
Received: from mail.suse.de ([195.135.220.2]:43759 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965814AbXCIUjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:39:36 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Fri, 9 Mar 2007 21:39:33 +0100
User-Agent: KMail/1.9.1
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703091509560.5094-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0703091509560.5094-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703092139.35184.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. März 2007 21:27 schrieb Alan Stern:
> On Fri, 9 Mar 2007, Oliver Neukum wrote:
> 
> > > Adding a new release() callback would solve the problem by creating 
> > > another.  Drivers need to release their data as soon as possible after
> > > they unbind from a device, not when the device itself goes away.  Think
> > 
> > Wait, the callback from closing the file in sysfs is the earliest we can safely
> > free the data structure. How do you want to free earlier?
> 
> It is _not_ the earliest we can safely free the data structure.
> 
> Dmitry's callback occurs when _all_ the sysfs attributes have been
> released -- including ones that don't have anything to do with the
> driver's private data structure.  Think of the bInterfaceClass attribute,
> for example.

Ok, yes I see. It is by far too late.

	Regards
		Oliver
