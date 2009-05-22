Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbZEVPTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbZEVPTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 11:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbZEVPTN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 11:19:13 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43414 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754590AbZEVPTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 11:19:12 -0400
Date: Fri, 22 May 2009 16:20:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kyle Moffett <kyle@moffetthome.net>,
       Pantelis Koukousoulas <pktoss@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
Message-ID: <20090522162014.5caa0823@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0905221051350.3006-100000@iolanthe.rowland.org>
References: <20090522105313.63e309f0@lxorguk.ukuu.org.uk>
	<Pine.LNX.4.44L0.0905221051350.3006-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't understand this comment.  By "probe" I assume you mean
> "initialize and enumerate", as opposed to calling various drivers'
> probe() routines -- let me know if this isn't what you meant.  If the
> kernel didn't initialize and enumerate devices by default, then when
> would they get initialized and enumerated?

When user space gets an event saying the bus itself exists and asks for
it to be scanned. The most obvious case where its currently broken is
partition tables on disks where you don't always want to read partition
tables automatically.

> 
> If your answer is "When requested by a user process", then I'll go on
> to ask: What about devices containing the root filesystem, the system 
> console, and so on?
> 
> And just how does initialization and enumeration mess up 
> virtualization?

It means that the bus scanning occurs out of control of the virtualised
environment which might want to control what occurs

> Anyway, enumeration isn't the problem.  The real problem has two parts:
> 
> 	Automatic probing and binding of kernel drivers, including
> 	selection and installation of a configuration (this really
> 	_does_ mess up virtualization).

If enumeration isn't automatic (or even more so if binding isn't always
automatic) then the problem doesn't occur.

> The second part can be solved (among cooperating processes) by use of
> port-lock files, with no kernel involvement.  The first part does
> require a kernel interface of some sort, but it wouldn't have to be
> complicated.  The mere fact that a port-lock file was open could be
> enough to prevent automatic configuration, probing, and binding.

Given the layout of devices can change fairly arbitarily would the
ability to claim specific device identifiers via libusb do the job any
better.

ie would it be better to expose an interface via libusb that was
essentially

	reserve_for_userspace(vendorid, devid);

