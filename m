Return-Path: <linux-kernel-owner+w=401wt.eu-S1762124AbZEGTzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762124AbZEGTzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 15:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZEGTz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 15:55:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53546 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751837AbZEGTzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 15:55:25 -0400
Date: Thu, 7 May 2009 15:55:22 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: Pantelis Koukousoulas <pktoss@gmail.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usbfs, claiming entire usb devices
In-Reply-To: <1295ed070905071015n5a604f93je366faf55b695e47@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0905071543470.4812-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a proposal afoot to give user programs the ability to claim
ownership of an entire USB device, rather than just individual
interfaces.  In fact, we'd like processes to be able to own whatever
device gets plugged into a particular port on a particular hub.

The question is how the API should work.  A simple approach is to have
a sysfs or usbfs file correspond to each port; when a process opens the
file it would be granted ownership of any device plugged into that
port.  Since the file is automatically closed when the process ends, we
wouldn't have to worry about ownership never getting released.

But there's a snag.  When a process goes to open the usbfs file for a
device, the kernel needs to know whether or not the process owns that
device.  In other words, we need to figure out whether or not the
process has opened the corresponding port file.

Is there a simple way to do this?  Is it reasonable to search through 
all the process's fd's, looking for one that matches a particular 
inode?

Or would a completely different API approach be better?

Thanks,

Alan Stern

