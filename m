Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbXKGUdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbXKGUdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 15:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXKGUdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 15:33:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58683 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753800AbXKGUdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 15:33:16 -0500
Date: Wed, 7 Nov 2007 12:32:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: Re: BUG: usb Mouse continual disconnect (2.6.22.10) leading to
 eventual crash?
Message-Id: <20071107123237.d318cdbf.akpm@linux-foundation.org>
In-Reply-To: <F1D642E5A91BC94D9504EC83AE19E6B0B89760@ecqcmtlmail3.quebec.int.ec.gc.ca>
References: <F1D642E5A91BC94D9504EC83AE19E6B0B89760@ecqcmtlmail3.quebec.int.ec.gc.ca>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(+linux-usb-devel)

> On Wed, 7 Nov 2007 13:19:47 -0500 "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA> wrote:
> Hi all,
> 
> I'm having a preblem with a few workstations that are hard freezing from
> time to time since about a week.  Curiously since then we upgraded from
> 2.6.20.6 to 2.6.20.10...
> 
> While investigating I found out that there seems to be a problem,
> occuring randomly on some workstations after a certain amount time, that
> the mouse gets disconnected continously (see full log attached):
> Nov  7 00:09:36 mammatus kernel: [22055.357104] usb 2-1: USB disconnect,
> address 2
> Nov  7 00:09:37 mammatus kernel: [22055.596974] usb 2-1: new low speed
> USB device using uhci_hcd and address 3
> Nov  7 00:09:37 mammatus kernel: [22055.777831] usb 2-1: configuration
> #1 chosen from 1 choice
> Nov  7 00:09:37 mammatus kernel: [22055.793905] input: Logitech USB-PS/2
> Optical Mouse as /class/input/input5
> Nov  7 00:09:37 mammatus kernel: [22055.793994] input: USB HID v1.10
> Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
> Nov  7 00:10:11 mammatus kernel: [22090.368722] usb 2-1: USB disconnect,
> address 3
> Nov  7 00:10:12 mammatus kernel: [22090.608588] usb 2-1: new low speed
> USB device using uhci_hcd and address 4
> Nov  7 00:10:12 mammatus kernel: [22090.784671] usb 2-1: configuration
> #1 chosen from 1 choice
> Nov  7 00:10:12 mammatus kernel: [22090.800881] input: Logitech USB-PS/2
> Optical Mouse as /class/input/input6
> Nov  7 00:10:12 mammatus kernel: [22090.800982] input: USB HID v1.10
> Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
> [.....]
> Nov  7 17:57:28 mammatus kernel: [86097.543960] input: Logitech USB-PS/2
> Optical Mouse as /class/input/input596
> Nov  7 17:57:28 mammatus kernel: [86097.544050] input: USB HID v1.10
> Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
> Nov  7 17:59:07 mammatus kernel: [86196.161272] usb 2-1: USB disconnect,
> address 112
> Nov  7 17:59:07 mammatus kernel: [86196.401142] usb 2-1: new low speed
> USB device using uhci_hcd and address 113
> Nov  7 17:59:08 mammatus kernel: [86196.577674] usb 2-1: configuration
> #1 chosen from 1 choice
> Nov  7 17:59:08 mammatus kernel: [86196.593834] input: Logitech USB-PS/2
> Optical Mouse as /class/input/input597
> Nov  7 17:59:08 mammatus kernel: [86196.593939] input: USB HID v1.10
> Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
> Nov  7 17:59:13 mammatus kernel: [86202.206449] usb 2-1: USB disconnect,
> address 113
> Nov  7 17:59:13 mammatus kernel: [86202.446319] usb 2-1: new low speed
> USB device using uhci_hcd and address 114
> Nov  7 17:59:14 mammatus kernel: [86202.623309] usb 2-1: configuration
> #1 chosen from 1 choice
> Nov  7 17:59:14 mammatus kernel: [86202.638402] input: Logitech USB-PS/2
> Optical Mouse as /class/input/input598
> Nov  7 17:59:14 mammatus kernel: [86202.638493] input: USB HID v1.10
> Mouse [Logitech USB-PS/2 Optical Mouse] on usb-0000:00:1d.0-1
> 
> There are some occasionnal connect/disconnect due to the fact that we
> recently bought an ergonomic mouse (Evoluent Vertical Mouse 3 Rev. 2)
> that some people plug-in the workstation they are working for the
> duration of their day/night shift... but nothing like 600 disconnect /
> day / workstations?  And actually, the source workstation of this log as
> not yet got the mouse connected to it since it's last reboot.
> 
> Looking at the changes between 2.6.20.6 and 2.6.20.10 I only found this
> USB related:
> http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.22.y.git;a=co
> mmit;h=0e22438a5adfdf32b3bb1c75c81c01a29fba9770
> 
> I'm presuming that maybie eventually it might hit a input max barrier
> (like a max of 1024) and then the kernel would be crashing?
> 
> Help very much appreciated!

People are going to want to know if this is still happening in 2.6.23
or 2.6.24-rc2, please.
