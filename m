Return-Path: <linux-kernel-owner+w=401wt.eu-S1758469AbYDDRO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758469AbYDDRO2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 13:14:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752615AbYDDROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 13:14:20 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:58537 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYDDROT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 13:14:19 -0400
Date: Fri, 4 Apr 2008 19:13:50 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: pci: add to global list before sysfs?
Message-ID: <20080404191350.7f0183a5@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I have a PCI hotplug problem I was hoping you could provide some
insight into.

I want the PCI layer to make sure that all subfunctions of a newly
added card are visible via pci_get_device() before any of them are
binded to drivers. I.e. I want pci_bus_add_devices() to first make a
pass and add the devices to the global list, then a second pass for
device_add().

The reason I want this is because I have at least two chips where I
need to know which other subfunctions are present on the card in order
to correctly initalise the subfunction I'm currently probing. Right now
that fails miserably as the driver does not see the other devices in
its probe function.

Is it possible to do this or will things break left and right if I
add them to the global list before I register them with the driver core?

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
