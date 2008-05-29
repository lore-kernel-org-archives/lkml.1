Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYE2UQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYE2UQE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 16:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752135AbYE2UPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 16:15:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40819 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbYE2UPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 16:15:53 -0400
Date: Thu, 29 May 2008 09:47:45 -0700
From: Greg KH <greg@kroah.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
	kernel.
Message-ID: <20080529164745.GA21763@kroah.com>
References: <1211995212.3445.52.camel@localhost.localdomain> <20080528.225826.40264516.davem@davemloft.net> <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu> <1212077700.26088.83.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212077700.26088.83.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 07:15:00PM +0300, David Woodhouse wrote:
> On Thu, 2008-05-29 at 08:45 -0400, Theodore Tso wrote:
> >  there is always the chance the topic will resolve itself via e-mail. 
> 
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

I like and agree with all of this.

> By the time the kernel summit comes around, we should have made decent
> progress on moving _all_ the firmware blobs to the firmware/ directory.

That's good too.

> And at that point I'd like to remove them completely, to a separate git
> tree and tarball. Those who really want to build them in to their static
> kernel would still be able to, but it wouldn't be the default behaviour.

This I disagree with.  Leaving it in a single directory makes it easier
for some distros to patch it away to apease their feelings about the
issue.  But for some of use, we like the firmware in our kernels, it
makes it easier to boot for one, and we don't have to deal with
different firmware packages.  So I say leave them in, with the option to
get them elsewhere, like you are doing.

thanks,

greg k-h
