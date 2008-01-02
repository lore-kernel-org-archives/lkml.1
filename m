Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbYABFgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbYABFgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 00:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbYABFgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 00:36:48 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41830 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYABFgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 00:36:47 -0500
Date: Tue, 1 Jan 2008 21:38:14 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Tino Keitel <tino.keitel@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Boaz Harrosh <bharrosh@panasas.com>, Alan Cox <alan@redhat.com>
Subject: Re: 2.6.24-rc6-git7: Reported regressions from 2.6.23
Message-ID: <20080102053814.GB25586@kroah.com>
References: <200801012202.57851.rjw@sisk.pl> <alpine.LFD.1.00.0801011408470.32517@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801011408470.32517@woody.linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 01, 2008 at 02:26:06PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 1 Jan 2008, Rafael J. Wysocki wrote:
> > 
> > Subject	: Could not set non-blocking flag with 2.6.24-rc5
> > Submitter	: Tino Keitel <tino.keitel@gmx.de>
> > Date		: 2007-12-13 16:27
> > References	: http://lkml.org/lkml/2007/12/13/392
> > 		  http://bugzilla.kernel.org/show_bug.cgi?id=9557
> > Handled-By	: 
> > Patch		: 
> 
> That strace shows that trying to open /dev/null fails with ENXIO:
> 
> 	[pid  6050] open("/dev/null", O_RDONLY <unfinished ...>
> 	[pid  6050] <... open resumed> )        = -1 ENXIO (No such device or address)
> 
> and everything goes downhill from there.
> 
> It would be worth looking at your /dev/null to see what kind of (broken) 
> device node it is, and get a clue about *why* it is broken.
> 
> Greg, any udev breakage that could affect /dev/null? 

I do not know of any such breakage.

But, as this is in a chroot, hopefully udev has properly populated the
chrooted /dev tree for the process to provide the /dev/null device node?

Tino, did you provide a /dev/ for your chroot?  Did you use udev to
create it, or did you use a static /dev tree?

thanks,

greg k-h
