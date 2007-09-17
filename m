Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbXIQAVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbXIQAVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 20:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbXIQAVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 20:21:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:48735 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbXIQAVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 20:21:38 -0400
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46EDBE39.4090704@shaw.ca>
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
	 <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no>
	 <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no>
	 <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
	 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
	 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no> <46EA00DA.6010704@shaw.ca>
	 <1189973176.6403.20.camel@localhost.localdomain> <46EDBE39.4090704@shaw.ca>
Content-Type: text/plain
Date: Mon, 17 Sep 2007 02:21:20 +0200
Message-Id: <1189988480.6403.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-16 at 17:37 -0600, Robert Hancock wrote:
> We would already have this problem, though. If it causes problems to 
> disable decode on the BAR because we try to access it in interrupt 
> context, we would already have problems because we move the thing to 
> 0xFFFFFFFF during probing anyway.. 

Yes, it's not a new problem, I was just pointing out the fact that there
are deeper issues already there in the same area.

Today, we mostly get lucky because we rarely take an irq during boot
time PCI probe but I've seen it happen (one easy way to screw things up
on -many- machines is to enable the DEBUG stuff in the PCI probe code
and use a serial console for example, especially if access to the device
with the serial ports in it gets temporarily cut off).

Cheers,
Ben.


