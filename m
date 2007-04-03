Return-Path: <linux-kernel-owner+w=401wt.eu-S2992527AbXDDAZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992527AbXDDAZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992524AbXDDAZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:25:43 -0400
Received: from adsl-216-102-214-42.dsl.snfc21.pacbell.net ([216.102.214.42]:51319
	"EHLO cynthia.pants.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992519AbXDDAZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:25:42 -0400
X-Greylist: delayed 2450 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2007 20:25:42 EDT
Date: Tue, 3 Apr 2007 15:10:02 -0700
From: Brad Boyer <flar@allandria.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070403221002.GA13210@cynthia.pants.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org> <17938.57292.870224.132415@cargo.ozlabs.ibm.com> <1175642916.10567.24.camel@shinybook.infradead.org> <20070403212928.GA12951@cynthia.pants.nu> <1175644642.10567.31.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1175644642.10567.31.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 07:57:22PM -0400, David Woodhouse wrote:
> > The TTY_MAJOR should have never belonged to 8250.c in the first place.
> > I know it's just my opinion, but I think this major device should be
> > owned by the serial core, and it shouldn't matter what chip drives each
> > individual port. Each hardware driver should just register with the
> > core how many ports it has and should be allocated from the same range.
> 
> Yeah, because that works out really well for Ethernet devices and SCSI
> disks, with different numbers every day of the week according to what
> order we happen to load drivers in. :)

It just leads to the problem ethernet has on BSD/Solaris/etc. You have
to ask yourself "is the ethernet on this system le0 or hme0 or maybe
something else entirely?" in this case. I agree it does solve the issue
of detection order breaking the configuration, but it is less than ideal.
I think the issue of the devices shuffling around is less likely to be
a problem on serial, although we don't have the nice uniqueness of
hardware identifiers that was used to do device renaming in ethernet.

I suppose my opinion on this shows that I didn't come from the x86
side of Linux. The breakdown on this argument seems to have always
been that the x86 people wanted 8250 to own ttyS* and most others
wanted it shared. I know it was that way when m68k tried to merge
in their serial framework that did allow such sharing across any
number of hardware drivers.

	Brad Boyer
	flar@allandria.com

