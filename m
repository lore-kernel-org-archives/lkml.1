Return-Path: <linux-kernel-owner+w=401wt.eu-S1161300AbXBGNlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161300AbXBGNlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 08:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161299AbXBGNlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 08:41:05 -0500
Received: from mail14.messagelabs.com ([212.125.75.19]:57913 "HELO
	mail14.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161300AbXBGNlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 08:41:04 -0500
X-VirusChecked: Checked
X-Env-Sender: martyn.welch@radstone.co.uk
X-Msg-Ref: server-11.tower-14.messagelabs.com!1170855662!59910!1
X-StarScan-Version: 5.5.10.7.1; banners=radstone.co.uk,-,-
X-Originating-IP: [193.130.116.242]
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
Subject: alloc_bootmem - Kernel panic
Date: Wed, 7 Feb 2007 13:41:02 -0000
Message-ID: <F38DEABE0E171746B133C1ABBD142D97063253D0@radmail.Radstone.Local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: alloc_bootmem - Kernel panic
Thread-Index: AcdKvZvcBNPbqGZNTRKeXbvyZl7MtA==
From: "Martyn Welch" <martyn.welch@radstone.co.uk>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everyone,

First I'd like to appologise if my query is glaringly obvious. I'm
reasonable new to this, but every that I have read (including the Linux
Device Drivers book) seems to suggest that what I am doing should
work...

I am attempting to allocate a large buffer for DMA transfers in a driver
I am working on. I understand that the kernel normally will not allocate
block of coherent memory larger than 128KB, the suggested solution seems
to be to compile the driver into the kernel and allocate memory at boot
using alloc_bootmem. When attempting this I receive a kernel panic:

=========================================

Loading driver.
bootmem alloc of 4096 bytes failed!
Kernel panic - not syncing: Out of memory

=========================================
This is using:

kernel version 2.6.20
gcc version 4.1.1 20070105 (Red Hat 4.1.1-51)

The config is based on the default i386 config + one extra option to
cause my driver to be compiled in.

The offending code is listed below,

Thank you for any help in advance,

Martyn

=========================================

#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/bootmem.h>

void *buffer;

static int __init universeII_init(void)
{
        printk(KERN_INFO "Loading driver.\n");

        buffer = alloc_bootmem(PAGE_SIZE);

        return 0;

}


static void __exit universeII_exit(void)
{
        if (buffer != NULL) {
                free_bootmem((unsigned long)buffer, PAGE_SIZE);
        }
        printk(KERN_INFO "Driver removed.\n");
}


MODULE_DESCRIPTION("alloc_bootmem_x Test");
MODULE_AUTHOR("Martyn Welch <martyn.welch@radstone.co.uk>");
MODULE_LICENSE("GPL");

/** Register initilisation function */
module_init(universeII_init);
/** Register cleanup function */
module_exit(universeII_exit);


________________________________________________________________________
This e-mail has been scanned for all viruses by Star.The service is powered by MessageLabs. 
________________________________________________________________________
