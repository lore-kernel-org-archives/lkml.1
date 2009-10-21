Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbZJUR0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbZJUR0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 13:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZJUR0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 13:26:43 -0400
Received: from perceval.irobotique.be ([92.243.18.41]:45264 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZJUR0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 13:26:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: uvcvideo causes ehci_hcd to halt
Date: Wed, 21 Oct 2009 19:27:00 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31.1; KDE/4.3.2; x86_64; ; )
Cc: Ozan =?utf-8?q?=C3=87a=C4=9Flayan?= <ozan@pardus.org.tr>,
       linux-media@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0910211052200.2847-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910211052200.2847-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910211927.00298.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 October 2009 17:07:51 Alan Stern wrote:
> On Wed, 21 Oct 2009, [UTF-8] Ozan Çağlayan wrote:
> > Nope it didn't help. Here's the DEBUG enabled dmesg output:
> 
> ...
> 
> > [  420.737748] usb 1-5: link qh1024-0001/f6ffe280 start 1 [1/0 us]
> 
> The periodic schedule was enabled here.
> 
> > [  420.737891] usb 1-5: unlink qh1024-0001/f6ffe280 start 1 [1/0 us]
> 
> And it was disabled here.  Do you have any idea why the uvcvideo driver
> submits an interrupt URB and then cancels it 150 us later?  The same
> thing shows up in the usbmon traces.

Probably because hal opens the device to query its capabilities and closes it 
right after. The driver submits the interrupt URB when the first user opens 
the device and cancels it when the last user closes the device.
 
-- 
Regards,

Laurent Pinchart
