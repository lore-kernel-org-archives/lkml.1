Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYE2TNm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYE2TNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYE2TNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:13:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49001 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbYE2TNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:13:33 -0400
Message-ID: <483F002E.5060002@garzik.org>
Date: Thu, 29 May 2008 15:12:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: Theodore Tso <tytso@mit.edu>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: RFC: Moving firmware blobs out of the kernel.
References: <1211995212.3445.52.camel@localhost.localdomain>	 <20080528.225826.40264516.davem@davemloft.net>	 <1212041839.8888.38.camel@pasglop>  <20080529124548.GC8065@mit.edu> <1212077700.26088.83.camel@shinybook.infradead.org>
In-Reply-To: <1212077700.26088.83.camel@shinybook.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> I'm kind of hoping that this is going to be one of those topics that
> resolves itself -- but just in case it isn't, I'd like to discuss it at
> the kernel summit:
> 
> I'd like to remove all firmware blobs from the kernel source tree.
> 
> With the intention of making that less contentious, I've done the
> following: 
> 
> I've added support to the firmware loader for finding firmware in a
> special section of the static kernel, so that using request_firmware()
> no longer forces you to use an initrd or udev. You can build _arbitrary_
> firmware files into your kernel, if you want to. Whether you're allowed
> to distribute the resulting vmlinux or not is still a question you ought
> to ask your lawyer.
> 
> I'm working on converting drivers over to use request_firmware(), and
> shifting their firmware blobs into .ihex files in a firmware/ directory
> of the source tree. For each one, I'm giving the option of continuing to
> build it in statically, using the above mechanism.
> 
> I've implemented a 'make firmware_install' Kbuild target, which takes
> all those firmware blobs and installs them somewhere where udev can load
> them on request.
> 
> By the time the kernel summit comes around, we should have made decent
> progress on moving _all_ the firmware blobs to the firmware/ directory.
> And at that point I'd like to remove them completely, to a separate git
> tree and tarball. Those who really want to build them in to their static
> kernel would still be able to, but it wouldn't be the default behaviour.


I like your idea, all the way to the point where you actually remove the 
firmware file from the kernel tree :)

I think it's a good move to make the firmware files standalone and not 
#include'd as a C header file, but it's just plain easier to ship them 
with the kernel tree in a lot of cases.  $FOO-firmware packages in 
Fedora prove other methods of firmware distribution are quite usable, 
but that does not therefore imply that in-kernel built-in firmwares have 
no utility.

Personally, living in an imaginary all-open-source world, I wouldn't 
mind seeing firmware source for firmware built into drivers, a la 
drivers/scsi/aic7xxx/aicasm/, living in the kernel tree.

If the firmware has a compatible license and is required for critical 
operations like booting the machine, built-in firmware should remain an 
option.  For certain embedded cases, I could certainly see that 
in-kernel firmware being the best method for firmware distribution, for 
both $Platform's users and $Platform's developers.

	Jeff



