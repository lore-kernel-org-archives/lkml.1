Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXC3WIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXC3WIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932266AbXC3WIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:08:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53459 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932263AbXC3WIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:08:42 -0400
Date: Fri, 30 Mar 2007 14:59:17 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Lord <mlord@pobox.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch 34/37] libata bugfix: HDIO_DRIVE_TASK
Message-ID: <20070330215917.GB5812@suse.de>
References: <20070330205938.984247529@mini.kroah.org> <20070330210659.GK29450@kroah.com> <460D8435.3060503@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460D8435.3060503@pobox.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2007 at 05:42:13PM -0400, Mark Lord wrote:
> Greg KH wrote:
> >-stable review patch.  If anyone has any objections, please let us know.
> >
> >------------------
> >From: Mark Lord <liml@rtr.ca>
> >
> >libata bugfix: HDIO_DRIVE_TASK
> >
> >I was trying to use HDIO_DRIVE_TASK for something today,
> >and discovered that the libata implementation does not copy
> >over the upper four LBA bits from args[6].
> >
> >This is serious, as any tools using this ioctl would have their
> >commands applied to the wrong sectors on the drive, possibly resulting
> >in disk corruption.
> >
> >Ideally, newer apps should use SG_IO/ATA_16 directly,
> >avoiding this bug.  But with libata poised to displace drivers/ide,
> >better compatibility here is a must.
> >
> >This patch fixes libata to use the upper four LBA bits passed
> >in from the ioctl.
> >
> >The original drivers/ide implementation copies over all bits
> >except for the master/slave select bit.  With this patch,
> >libata will copy only the four high-order LBA bits,
> >just in case there are assumptions elsewhere in libata (?).
> >
> >Signed-off-by: Mark Lord <mlord@pobox.com>
> >Cc: Chuck Ebbert <cebbert@redhat.com>
> >Signed-off-by: Jeff Garzik <jeff@garzik.org>
> >Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ..
> 
> Mmmm.. I've just noticed another bit we should  be preserving there,
> both for *stable* and current mainline.
> 
> Instead of:
> 
> >+	scsi_cmd[13] = args[6] & 0x0f;
> 
> We should be doing:
> 
> >+	scsi_cmd[13] = args[6] & 0x4f;
> 
> As-is, the patch still helps, but it is not as useful as it could be.
> Here's the fixed version.  I'm also sending out a 2.6.21 patch via Jeff.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>

Can you forward that one to the stable@kernel.org address too, with the
full changelog and Jeff's ack/signed-off-by so that I will remember to
add it to the tree?

thanks,

greg k-h
