Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbXCTL4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbXCTL4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbXCTL4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:56:44 -0400
Received: from aun.it.uu.se ([130.238.12.36]:51664 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbXCTL4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:56:41 -0400
Date: Tue, 20 Mar 2007 12:56:02 +0100 (MET)
Message-Id: <200703201156.l2KBu2o5024611@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: ak@suse.de, mikpe@it.uu.se
Subject: Re: [PATCH][5/5][resend] floppy.c: Fix device_create_file() warning
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bzolnier@gmail.com,
       jesper.juhl@gmail.com, linux-kernel@vger.kernel.org,
       trent.waddington@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Mar 2007 12:29:49 +0100 (CET), Andreas Kleen <ak@suse.de> wrote:
> > The floppy driver's sysfs file just provides some auxiliary
> > information to user-space, none of which matters for most of
> > its users. It is IMO totally inappropriate to fail floppy
> > driver init in this case.
> 
> I thought it was for udev to create the device nodes? But
> I might be wrong on that.

It's a file called "cmos" containing the ASCII
representation of UDP->cmos, which appears to be some
kind of "type" indicator. See floppy_cmos_show().

The file is only readable, not even root can write to it.

On one of my machines it contains the value "4", but the
device nodes udev created are still just /dev/fd0 and
/dev/floppy -> /dev/fd0, so I don't think it affects udev.

The "cmos" file seems to be a relatively new addition,
as another machine here running an RHEL4 2.6.9 kernel
doesn't have it.

Unless someone can prove that it's useful I think it
should be removed.

/Mikael
