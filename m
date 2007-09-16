Return-Path: <linux-kernel-owner+w=401wt.eu-S1753818AbXIPUGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbXIPUGf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:06:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbXIPUG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:06:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:55080 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbXIPUG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:06:27 -0400
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <gregkh@suse.de>,
       Matthew Wilcox <matthew@wil.cx>, Shaohua Li <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <46EA00DA.6010704@shaw.ca>
References: <fa.ggBqx6W3i6hfs6jdfg64oXKSxW8@ifi.uio.no>
	 <fa.o5cJ0O7pLVWRzUiVPDEZL6nKqA8@ifi.uio.no>
	 <fa.tyYt4GOpTOmJTUbzsxpiCAObJPQ@ifi.uio.no>
	 <fa.13eJumylqINOxOaoEj9cthw0d0M@ifi.uio.no>
	 <fa.tAIuIM02CoL+ixB11n9Fmcqyz9M@ifi.uio.no>
	 <fa.pxFYhTaUz2NVN7Vux7b5xVRrKTw@ifi.uio.no>  <46EA00DA.6010704@shaw.ca>
Content-Type: text/plain
Date: Sun, 16 Sep 2007 22:06:16 +0200
Message-Id: <1189973176.6403.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-13 at 21:32 -0600, Robert Hancock wrote:
> 
> If we do encounter other devices that choke on having the BAR
> disabled 
> during probing then we can add additional quirk logic, but we haven't 
> run into anything like that yet.

Well... if the device needs to be accessed to service an interrupt then
you do have a problem. For example... the PIC :-)

Problem is.. it's not practical nor really feasible generally to have
IRQs off on all CPUs during PCI probing neither... Unless we define that
the initial boot time probing is "special", and the first pass that
actually probes devices (and doesn't muck around with the sysfs
hierarchy etc...) can be run in a special context with all interrupt
servicing disabled on the PIC, though that will require some arch
support.

Ben.


