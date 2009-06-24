Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZFXL2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZFXL2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbZFXL2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:28:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:45968 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZFXL2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:28:46 -0400
Subject: Re: Bluetooth HID devices not getting properly removed
From: David Woodhouse <dwmw2@infradead.org>
To: Thomas =?ISO-8859-1?Q?B=E4chler?= <thomas@archlinux.org>
Cc: linux-kernel@vger.kernel.org, marcel@holtmann.org
In-Reply-To: <4A4209D2.4060209@archlinux.org>
References: <4A4209D2.4060209@archlinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Jun 2009 12:28:46 +0100
Message-Id: <1245842926.25547.5415.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 13:11 +0200, Thomas Bächler wrote:
> 
> KERNEL[1245834012.631443] remove 
> /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/bluetooth/hci0/hci0:11 
> (bluetooth)
> KERNEL[1245834012.632668] remove   /hci0:11/input12/mouse2 (input)
> KERNEL[1245834012.641797] remove   /hci0:11/input12/event8 (input)
> KERNEL[1245834012.655447] remove   /hci0:11/input12 (input)
> KERNEL[1245834012.655502] remove   /hci0:11/0005:046D:B002.0004 (hid)
> 
> See how the device path of the removed input devices is truncated? When 
> I do the same with a USB mouse, a full device path is returned each time.
> 
> All of this results in hal not removing its logical input device, which 
> means the number of (non-existent) mice in the hal device tree increases 
> whenever I disable and re-enable my mouse.
> 
> So where do I put this bug? Linux? Bluez? Udev? Hal? My guess is Linux, 
> as these device paths come from Linux originally and are in fact 
> inconsistent. This is all tested on 2.6.30, I have no idea if it was the 
> case on older kernels.

It's in the BlueZ HID code. I pointed it out to Marcel a few months ago
-- it happens when the ACL connection is killed (orphaning the HID
device in sysfs), and the HID device is only killed _later_, so the path
on the removal is wrong.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

