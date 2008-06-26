Return-Path: <linux-kernel-owner+w=401wt.eu-S1759983AbYFZR5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbYFZR5P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759867AbYFZR4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:56:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58081 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805AbYFZR4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:56:53 -0400
Subject: Ambiguous dupe in libusual device list
From: Ben Collins <ben.collins@canonical.com>
To: usb-storage <usb-storage@lists.one-eyed-alien.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Organization: Canonical
Date: Thu, 26 Jun 2008 13:32:36 -0400
Message-Id: <1214501556.7150.36.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In unusual_devs.h, there are these two entries:

#ifdef CONFIG_USB_STORAGE_DATAFAB
/* Submitted by Olaf Hering <olh@suse.de> */
UNUSUAL_DEV(  0x07c4, 0xa109, 0x0000, 0xffff,
                "Datafab Systems, Inc.",
                "USB to CF + SM Combo (LC1)",
                US_SC_SCSI, US_PR_DATAFAB, NULL,
                0 ),
#endif
#ifdef CONFIG_USB_STORAGE_SDDR55
/* SM part - aeb <Andries.Brouwer@cwi.nl> */
UNUSUAL_DEV(  0x07c4, 0xa109, 0x0000, 0xffff,
                "Datafab Systems, Inc.",
                "USB to CF + SM Combo (LC1)",
                US_SC_SCSI, US_PR_SDDR55, NULL,
                US_FL_SINGLE_LUN ),
#endif

If I'm not mistaken (and because libusual is pretty well abstracted, I
might be) this is an ambiguous dupe that isn't resolved with any
checking (IOW, the second entry is likely never used), at least when
both config options are enabled.

If that's not the case, then maybe a comment would be in order? If the
case is that these two options should not be enabled at the same time,
then perhaps some Kconfig magic is required.

