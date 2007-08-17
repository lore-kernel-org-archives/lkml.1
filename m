Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbXHQOub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbXHQOub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:50:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbXHQOuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:50:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49251 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751485AbXHQOuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:50:24 -0400
Date: Fri, 17 Aug 2007 10:50:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel
 events? [u]
In-Reply-To: <200708171622.05115.aj@ciphirelabs.com>
Message-ID: <Pine.LNX.4.44L0.0708171047170.2546-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Aug 2007, Andreas Jellinghaus [c] wrote:

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9f8b17e643fe6aa505629658445849397bda4e4f
> 
> removes MODALIAS from one of the events, this breaks user space applications 
> like openct - everything that depends on getting an event that has both the
> DEVICE= path to the usb device and any information on the interface, so it
> can check if the device is something it supports (in case of openct:
> smart card reader, i.e. bInterfaceClass 0b).

There is no MODALIAS for these events because there are no drivers for 
the devices they report.  Perhaps you should be looking at 
usb_if_uevent() in drivers/usb/core/message.c instead.  Is the problem 
that this routine doesn't set DEVICE, BUSNUM, or DEVNUM?

Alan Stern

