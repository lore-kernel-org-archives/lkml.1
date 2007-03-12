Return-Path: <linux-kernel-owner+w=401wt.eu-S1030474AbXCLP7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030474AbXCLP7a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 11:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030468AbXCLP7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 11:59:30 -0400
Received: from mx1.suse.de ([195.135.220.2]:50228 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030474AbXCLP73 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 11:59:29 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: Novell
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
Date: Mon, 12 Mar 2007 16:59:26 +0100
User-Agent: KMail/1.9.1
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Maneesh Soni" <maneesh@in.ibm.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0703121041400.2489-100000@iolanthe.rowland.org> <200703121623.58607.oneukum@suse.de> <d120d5000703120842k4e134136v2fe56dcfc2264841@mail.gmail.com>
In-Reply-To: <d120d5000703120842k4e134136v2fe56dcfc2264841@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703121659.27348.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 12. März 2007 16:42 schrieb Dmitry Torokhov:
> On 3/12/07, Oliver Neukum <oneukum@suse.de> wrote:
> > Am Montag, 12. März 2007 15:57 schrieb Alan Stern
> > > No, you're missing the point.  Let's say driver A's disconnect() is
> > > called, so the driver marks its private data structure as "disconnected"
> > > and does dev_set_drvdata(NULL).  Then driver B is probed and bound to the
> > > device, and it does its own dev_set_drvdata().  Then a user still holding
> > > an open sysfs file reference for driver A calls a show() or store()
> > > method.  The method will do dev_get_drvdata(), receiving the pointer to
> > > driver B's private data.  Now you're in trouble, because A's method will
> > > think it owns B's private data!
> >
> > Yes, I was missing the point. In consequence, drivers must not use
> > dev_get_drvdata() to get their references to their private data. It's
> > probably necessary to store it in struct sysfs_buffer and include that
> > in the store/show callbacks.
> > (The same does apply to interfaces of course)
> >
> 
> Or drivers coudl verify that they still bound to the device they are
> about to operate on (psmouse does this by taking a lock on device and
> then checking if driver bound is the same address as psmouse). But I'd
> rather get rid of all this clutter if we could sever sysfs access
> after removing corresponding attributes.

No, the call has to fail if the driver is rebound to the device.

	Regards
		Oliver
