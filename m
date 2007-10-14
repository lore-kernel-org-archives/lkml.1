Return-Path: <linux-kernel-owner+w=401wt.eu-S1763996AbXJNSq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763996AbXJNSq0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762937AbXJNSqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:46:00 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:49113 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762137AbXJNSp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:45:58 -0400
Date: Sun, 14 Oct 2007 20:45:57 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Philip <phibo@phibo.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: System.map
In-Reply-To: <20071014190738.58349165.phibo@phibo.org>
Message-ID: <Pine.LNX.4.64.0710142039040.22801@fbirervta.pbzchgretzou.qr>
References: <20071014190738.58349165.phibo@phibo.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 14 2007 19:07, Philip wrote:
>
>I want to write a script, which shows the name of the relevant
>kernel module for each listed pci device shown by 'lspci -m'. It's
>easy to find out the name of the corresponding module, if the driver
>has been compiled as a loadable kernel module: The file
>/lib/modules/$(uname -r)/modules.pcimap lists module names based on
>pci device's vendor -and device id (shown by 'lspci -n'). But how
>can I find out the name of the corresponding kernel module if the
>module has been compiled directly into the kernel ?

Well if it is compiled in, it is not a module, so you cannot find it
the usual way.

>I thought that I
>can find them in the kernel's machting System.map based on vendor
>-and device id as well. But I can't find those id's there. Where do
>I have to look for it ? I want to be informed by my script, if the
>driver (module) for a specific pci device is available as a loadable
>module, in-kernel module or not available at all.

That does not work reliably either. There might be PCI devices
which have the same PID:VID, but need a readb() or so for further
finding out whether the actual piece of hardware has a driver.

And then there is that sort of modules which do not have typical IDs
(i.e. udev cannot/won't autoload them) at all, like pcspkr.ko/psmouse.ko
