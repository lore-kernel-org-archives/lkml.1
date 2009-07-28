Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbZG1Ods@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbZG1Ods (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbZG1Odr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:33:47 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38891 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750902AbZG1Odq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:33:46 -0400
Date: Tue, 28 Jul 2009 10:33:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: 31-rc3-mmotm0716 - dead USB trackball mouse kills entire system
In-Reply-To: <70893.1248739158@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.44L0.0907281031020.2881-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 Valdis.Kletnieks@vt.edu wrote:

> Confirming - the patch in that thread prevents the system lockup I was
> seeing.
> 
> So it looks like hid_reset() getting more chatty sometime in the last 2 weeks
> was a red herring, and one I can't actually complain about - it was quite
> legitimately whinging about not being able to reset a device that was in fact
> dead in the water at the time.  Given that, and a working patch for ehci-hcd.c,
> I'm having a hard time finding the enthusiasm to track down what exactly
> changed in hid-core.c. :)
> 
> The change in hid-core.c behavior just had the bad luck to land in -mmotm at
> the exact same time the bug in ehci-hcd.c landed.  So we had two user-visible
> behavior changes in the same area of code at the same time.  Hilarity ensues. :)
> 
> Thanks for pointing me at the actual fix. ;)

A question for you: Do you now observe any warnings in the dmesg log if
you rmmod ehci-hcd after the trackball mouse is gone?  Apparently the 
patch you tested isn't perfect and some stuff gets leaked.  I'm trying 
to track down the problem.

Alan Stern

