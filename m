Return-Path: <linux-kernel-owner+w=401wt.eu-S1757233AbYIRVOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233AbYIRVOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 17:14:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbYIRVOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 17:14:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35007 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757110AbYIRVOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 17:14:35 -0400
Date: Thu, 18 Sep 2008 17:14:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: suspend (uhci_hcd) defunct in mmotm 2008-09-13-03-09
In-Reply-To: <48D1346C.1020203@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0809181708500.17483-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008, Jiri Slaby wrote:

> Hi,
> 
> I've found suspend on my desktop defunct in mmotm 2008-09-13-03-09 (opposing to
> 2008-09-10-19-39).
> 
> Dmesg says:
> 
> uhci_hcd 0000:00:1d.1: PCI INT B disabled
> pci_legacy_suspend(): usb_hcd_pci_suspend+0x0/0x3e0 returns -16
> pm_op(): pci_pm_suspend+0x0/0xd0 returns -16
> PM: Device 0000:00:1d.0 failed to suspend: error -16
> PM: Some devices failed to suspend

The reason for this error is that the root hub wasn't already 
suspended.  Was there a USB device plugged into that controller?

Two days ago I ran 2.6.27-rc6 plus gregkh-all-2.6.27-rc6.patch from

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

on my laptop, and it suspended with no problem.  Can you try the same 
kernel?

If you still run into problems, post more of the dmesg log (with 
CONFIG_USB_DEBUG enabled, of course!).

Alan Stern

