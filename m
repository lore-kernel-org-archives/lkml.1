Return-Path: <linux-kernel-owner+w=401wt.eu-S1758046AbZDOCmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758046AbZDOCmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZDOCm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:42:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:60143 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbZDOCm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:42:28 -0400
Date: Tue, 14 Apr 2009 19:44:14 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090414194414.22c63728@infradead.org>
In-Reply-To: <49E546C4.1060001@garzik.org>
References: <49E4FAC6.1030400@garzik.org>
	<20090414183807.3baf72ed@infradead.org>
	<49E546C4.1060001@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 22:30:28 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Arjan van de Ven wrote:
> > This change just made it go faster enough for you to be out of luck;
> > fundamentally your userland needs to wait if the device it wants is
> > not there. 
> 
> All these drivers are in-kernel, and the root device is passed via 
> command line.  There is no userland at that point, that needs to wait.

ok fair; but that does not change that the kernel does not know if a
device is coming.
Yes that sucks; sadly USB is just this way, you don't know when no new
devices will come from a certain bus.

> 
> If this change added an implicit initramfs requirement, that is a
> pretty major regression.

it didn't; this is what root_wait is for.


Having said that, I have a patch that basically retries this stuff
inside the kernel if the mount-of-rootfs fails....

(but it's independent of the usb improvement)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
