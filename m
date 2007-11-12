Return-Path: <linux-kernel-owner+w=401wt.eu-S1758745AbXKLSD7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745AbXKLSD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 13:03:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXKLSDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 13:03:52 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:60324 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbXKLSDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 13:03:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=sGVe4yWaqolCMvx9Wfs/3C7yWVTcU0XPazWKTqWdbQ7ImecCMh7wXhFcBYN9joF1p2oDG6lKzR0Rnj49Y/fsyLCy7Up46+/4PyUut6h/7bJTkUy/VdlAoNFjak9HWnvIhzrWmf5TRhNlz+3b5ldwELBH+hd3XxLf15/D0pJQFyk=
Message-ID: <93d1fdd10711121003t2286493bob25a3acd12134720@mail.gmail.com>
Date: Mon, 12 Nov 2007 13:03:50 -0500
From: "Ron Yorgason" <yorgasor@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Better support for Delkin cardbus CF adapters -- IDE layer
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me with any responses, I'm not on the lkml.

I'm trying to build a budget SSD using cardbus CF adapters & fast CF
cards.  The latest CF adapters support UDMA and PIO access methods,
and CF cards support these too.  The latest Delkin model boasts speeds
of 45MB/s.

I currently own this card from Synchrotech,
http://www.synchrotech.com/products/media-adapters-pcmcia-memory-cards_01.html
as well as the latest Delkin model.  The Synchrotech is recognized as
a Delkin, with PCI vendor id =0x1145, device id = 0xf021.  The new
Delkin has device id 0xf103.  I presume that in order to have the new
Delkin recognized, I just need to add the appropriate line to the
struct pci_device_id table.

But I'm concerned about performance.  The delkin_cb.c file states:

 *  This is slightly peculiar, in that it is a PCI driver,
 *  but is NOT an IDE PCI driver -- the IDE layer does not directly
 *  support hot insertion/removal of PCI interfaces, so this driver
 *  is unable to use the IDE PCI interfaces.  Instead, it uses the
 *  same interfaces as the ide-cs (PCMCIA) driver uses.
 *  On the plus side, the driver is also smaller/simpler this way.


My attempts to use hdparm to turn on DMA for my device have failed.  I
assume this means DMA is not currently supported.  In my tests, read
support seems fast enough, but writing maxes out around 2MB/s.  And if
there is a lot of reading and writing going on (ie, trying to compile
the kernel), performance is pretty abysmal.  What would it take to get
proper DMA support?  Is it an architecture problem, in that this
doesn't use the normal IDE PCI driver?  Is it a lack of documentation
on card specs?  What can I do to help?

--Ron
