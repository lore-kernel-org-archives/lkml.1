Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZEVQE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZEVQE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 12:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756423AbZEVQEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 12:04:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55927 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754323AbZEVQEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 12:04:50 -0400
Date: Fri, 22 May 2009 12:04:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
In-Reply-To: <20090522162014.5caa0823@lxorguk.ukuu.org.uk>
Message-ID: <Pine.LNX.4.44L0.0905221155140.3006-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Alan Cox wrote:

> > And just how does initialization and enumeration mess up 
> > virtualization?
> 
> It means that the bus scanning occurs out of control of the virtualised
> environment which might want to control what occurs

With USB this isn't much of an issue.  There are almost no
device-specific parameters affecting enumeration and none affecting
initialization -- understandably, since before initialization the
kernel doesn't know what kind of device it's dealing with.

> > Anyway, enumeration isn't the problem.  The real problem has two parts:
> > 
> > 	Automatic probing and binding of kernel drivers, including
> > 	selection and installation of a configuration (this really
> > 	_does_ mess up virtualization).
> 
> If enumeration isn't automatic (or even more so if binding isn't always
> automatic) then the problem doesn't occur.

I disagree.  For one thing, probing of kernel drivers doesn't occur
during enumeration.  So we could have automatic enumeration without
automatic probing, and there would be no problem.  For another, even if
enumeration were the direct cause of some problem, it would still
cause that same problem whenever it occurred, whether automatically or
not.

> > The second part can be solved (among cooperating processes) by use of
> > port-lock files, with no kernel involvement.  The first part does
> > require a kernel interface of some sort, but it wouldn't have to be
> > complicated.  The mere fact that a port-lock file was open could be
> > enough to prevent automatic configuration, probing, and binding.
> 
> Given the layout of devices can change fairly arbitarily would the
> ability to claim specific device identifiers via libusb do the job any
> better.
> 
> ie would it be better to expose an interface via libusb that was
> essentially
> 
> 	reserve_for_userspace(vendorid, devid);

That's a good question.  I'll defer to the interested parties.  
Kyle and Pantelis, what do you think?

Alan Stern

