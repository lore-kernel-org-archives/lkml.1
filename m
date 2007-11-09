Return-Path: <linux-kernel-owner+w=401wt.eu-S1760850AbXKILES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbXKILES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 06:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbXKILEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 06:04:11 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50774 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXKILEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 06:04:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
Date: Fri, 9 Nov 2007 12:03:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       virtualization@lists.osdl.org, linux-kernel@vger.kernel.org
References: <11944899922822-git-send-email-aliguori@us.ibm.com> <200711081846.36821.arnd@arndb.de> <47335DC6.7090603@us.ibm.com>
In-Reply-To: <47335DC6.7090603@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711091203.54665.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/MApn+/1GpXSAQ6wiNEHGtEar0qnnWhevvyCF
 z/4rrsI/etezArjtoDPwLfAdEuk9ZbN/doHdEgS4nJPXwB3omw
 a2xe69fJhU2M0mYGvObsg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007, Anthony Liguori wrote:
> 
> They already show up underneath of the PCI bus.  The issue is that there 
> are two separate 'struct device's for each virtio device.  There's the 
> PCI device (that's part of the pci_dev structure) and then there's the 
> virtio_device one.  I thought that setting the dev.parent of the 
> virtio_device struct device would result in having two separate entries 
> under the PCI bus directory which would be pretty confusing 

But that's what a device tree means. Think about a USB disk drive: The drive
shows up as a child of the USB controller, which in turn is a child of
the PCI bridge. Note that I did not suggest having the virtio parent set to
the parent of the PCI device, but to the PCI device itself.

I find it more confusing to have a device just hanging off the root when
it is actually handled by the PCI subsystem.

	Arnd <><
