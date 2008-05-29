Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYE2VSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYE2VSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:18:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758060AbYE2VSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:18:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46138 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041AbYE2VSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:18:33 -0400
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
In-Reply-To: <483F002E.5060002@garzik.org>
References: <1211995212.3445.52.camel@localhost.localdomain>
	 <20080528.225826.40264516.davem@davemloft.net>
	 <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>
	 <1212077700.26088.83.camel@shinybook.infradead.org>
	 <483F002E.5060002@garzik.org>
Content-Type: text/plain
Date: Thu, 29 May 2008 23:17:44 +0200
Message-Id: <1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-29 at 15:12 -0400, Jeff Garzik wrote:
> David Woodhouse wrote:
> > I'm kind of hoping that this is going to be one of those topics that
> > resolves itself -- but just in case it isn't, I'd like to discuss it at
> > the kernel summit:
> > 
> > I'd like to remove all firmware blobs from the kernel source tree.
> > 
> > With the intention of making that less contentious, I've done the
> > following: 
> > 
> > I've added support to the firmware loader for finding firmware in a
> > special section of the static kernel, so that using request_firmware()
> > no longer forces you to use an initrd or udev. You can build _arbitrary_
> > firmware files into your kernel, if you want to. Whether you're allowed
> > to distribute the resulting vmlinux or not is still a question you ought
> > to ask your lawyer.
> > 
> > I'm working on converting drivers over to use request_firmware(), and
> > shifting their firmware blobs into .ihex files in a firmware/ directory
> > of the source tree. For each one, I'm giving the option of continuing to
> > build it in statically, using the above mechanism.
> > 
> > I've implemented a 'make firmware_install' Kbuild target, which takes
> > all those firmware blobs and installs them somewhere where udev can load
> > them on request.
> > 
> > By the time the kernel summit comes around, we should have made decent
> > progress on moving _all_ the firmware blobs to the firmware/ directory.
> > And at that point I'd like to remove them completely, to a separate git
> > tree and tarball. Those who really want to build them in to their static
> > kernel would still be able to, but it wouldn't be the default behaviour.
> 
> 
> I like your idea, all the way to the point where you actually remove the 
> firmware file from the kernel tree :)
> 
> I think it's a good move to make the firmware files standalone and not 
> #include'd as a C header file, but it's just plain easier to ship them 
> with the kernel tree in a lot of cases.  $FOO-firmware packages in 
> Fedora prove other methods of firmware distribution are quite usable, 
> but that does not therefore imply that in-kernel built-in firmwares have 
> no utility.
> 
> Personally, living in an imaginary all-open-source world, I wouldn't 
> mind seeing firmware source for firmware built into drivers, a la 
> drivers/scsi/aic7xxx/aicasm/, living in the kernel tree.
> 
> If the firmware has a compatible license and is required for critical 
> operations like booting the machine, built-in firmware should remain an 
> option.  For certain embedded cases, I could certainly see that 
> in-kernel firmware being the best method for firmware distribution, for 
> both $Platform's users and $Platform's developers.

I certainly agree, pushing more and more into initrd just annoys the
hell out of me.

I'd argue to include everything needed to build (and esp cross build) an
initrd into the kernel - up until that point initrds are useless.


