Return-Path: <linux-kernel-owner+w=401wt.eu-S1757971AbXLHJY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971AbXLHJY6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 04:24:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbXLHJYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 04:24:50 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37956 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755160AbXLHJYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 04:24:49 -0500
Date: Sat, 8 Dec 2007 01:23:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Len Brown <lenb@kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-Id: <20071208012354.c808f9d7.akpm@linux-foundation.org>
In-Reply-To: <20071208082815.GB30997@elte.hu>
References: <200712080340.49546.rjw@sisk.pl>
	<b637ec0b0712072253k7f7410b6iaebf5b7b64ae4509@mail.gmail.com>
	<20071208082815.GB30997@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 09:28:15 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Fabio Comolli <fabio.comolli@gmail.com> wrote:
> 
> > <snip>
> > 
> > > Subject         : Battery shows up twice in kpowersave
> > > Submitter       : Rolf Eike Beer <eike-kernel@sf-tec.de>
> > > References      : http://bugzilla.kernel.org/show_bug.cgi?id=9494
> > > Handled-By      : Alexey Starikovskiy <astarikovskiy@suse.de>
> > > Patch           :
> > >
> > 
> > I don't think that this is a regression: I reported on RedHat bugzilla 
> > when I switched from F7 to F8 and I was using 2.6.23.8 at that time. 
> > It looks to me an HAL regression, but of course I may be wrong :-) as 
> > the reported bisected to a bad commit.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=373041
> > 
> > By the way, I now switched to Fedrora Rawhide with a 2.6.24-rc4-git5 
> > custom kernel and Gnome desktop and the problem is still present, even 
> > with gnome-power-manager.
> 
> to me this looks like an ABI regression - utilities should work without 
> change. Something changed in /sys output that caused HAL to think that 
> there are two batteries:

Yep.  Although HAL is of course a most special case of "userspace".

> | The output of lshal shows that there are two UDI's with 
> | info.capabilities = { 'battery' }:
> |
> | udi = '/org/freedesktop/Hal/devices/acpi_BAT0'
> | udi = '/org/freedesktop/Hal/devices/computer_power_supply_0'
> 
> whether it's a HAL bug or a kernel bug, the original state should be 
> restored and it should be worked out without breaking users of older HAL 
> versions.

"breaking users of older HAL versions" == "breaking machines".

The patch should be reverted.  Do we know which one it was?

> grumble: way too many times do various system utilities break when i 
> upgrade the kernel on my laptop. Maybe a new debug mechanism: we should 
> start fingerprinting the exact /sys and /proc output and enforce that 
> it's immutable across kernel releases as long as the hardware is 
> unmodified?

That would be neat.  It would need to be executed on a lot of different
machines.

I wonder if there's something sneaky we can do here.  Install the script in
/lib/modules/$(uname -r) and then run it from the kernel when the fork
count reaches 1000 ;)

(hey, I've seen worse: /proc files which start with #!/bin/sh)
