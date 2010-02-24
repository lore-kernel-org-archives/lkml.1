Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0BXQkh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:40:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60331 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752894Ab0BXQkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:40:36 -0500
Date: Wed, 24 Feb 2010 11:40:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: <akos@maroy.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
In-Reply-To: <201002232217.19201.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1002241137030.2436-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Rafael J. Wysocki wrote:

> On Tuesday 23 February 2010, Ákos Maróy wrote:
> > Hi,
> > 
> > I wonder if this is the write place to post this issue to, but I have a
> > proplem when trying go suspend or hibernate my system. after enabling
> > pm_trace by:
> > 
> > echo 1 > /sys/power/pm_trace
> > 
> > and then issuing pm-suspend, I get the following in dmesg:
> > 
> > [  685.833275] PM: Entering mem sleep
> > [  685.833292] Suspending console(s) (use no_console_suspend to debug)
> > [  685.993399] pm_op(): usb_dev_suspend+0x0/0x10 returns -2
> > [  685.993404] PM: Device usb2 failed to suspend: error -2
> > [  685.993408] PM: Some devices failed to suspend
> > [  685.997009] PM: resume devices took 0.000 seconds
> > [  685.997169] PM: Finishing wakeup.
> > 
> > this is on 2.6.32.8, but on 2.6.33-rc8 I get the same results.
> > 
> > trying to find out what device this is:
> > 
> > $ lsusb
> > Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > Bus 001 Device 003: ID 0bda:0159 Realtek Semiconductor Corp.
> > Bus 001 Device 004: ID 04f2:b16c Chicony Electronics Co., Ltd
> > Bus 001 Device 005: ID 03f0:231d Hewlett-Packard
> > Bus 001 Device 002: ID 8087:0020
> > Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
> > 
> > my persumption is that "Device usb2" would be device 002 on bus 001
> > above, that is, 8087:0020.

It isn't.  usb2 is the root hub device on bus 2, i.e., it is device 001 
on bus 002.

> > googling for this USB id I found some
> > references here: http://forum.notebookreview.com/showthread.php?p=5906076 :
> > 
> > Bus 001 Device 002: ID 8087:0020 Intel Corp. Integrated Rate Matching Hub
> > 
> > 
> > I wonder what could be done to make this device not sabotage the suspend
> > process?

You can get more information if you enable CONFIG_USB_DEBUG in your
kernel configuration.  The most likely explanation is that the suspend
failed because one of the ports on that root hub issued a wakeup
request.

Alan Stern

