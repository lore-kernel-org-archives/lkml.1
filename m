Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051AbYCKWog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051AbYCKWog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751098AbYCKWoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:44:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36823 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYCKWmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:42:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Date: Tue, 11 Mar 2008 23:41:41 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Greg KH <greg@kroah.com>
References: <200803110014.52985.rjw@sisk.pl> <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org> <47D6D61F.4050805@garzik.org>
In-Reply-To: <47D6D61F.4050805@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112341.42517.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of March 2008, Jeff Garzik wrote:
> Linus Torvalds wrote:
> > On Mon, 10 Mar 2008, Jeff Garzik wrote:
> >>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10123
> >>> Subject		: No power-off / reboot with 2.6.25-rcX (up to -rc3)
> 
> >> FWIW, I have this same problem.
> 
> > Jeff, does that one ("keep rd->online and cpu_online_map in sync") fix the 
> > problem for you?
> 
> Nope.  I am running baadac8b10c5ac15ce3d26b68fa266c8889b163f now, and it 
> still hangs on reboot or power-off.
> 
> Interestingly, if I reboot -immediately- from gdm, it succeeds.  However 
> if I login to Fedora GNOME via gdm, and load my standard apps (1001 
> terminals, firefox, tbird, IRC) reboot and poweroff no longer work.
> 
> My guess was always some ACPI regression.  I'll bisect today or 
> tomorrow.  It is reproducible regression that appeared recently (circa 
> 2.6.24 or 2.6.25-rc1 I think), so I should be able to find the culprit.

In http://bugzilla.kernel.org/show_bug.cgi?id=10123 Guennadi says that
reverting

commit fd7d1ced29e5beb88c9068801da7a362606d8273
Author: Greg Kroah-Hartman <gregkh@suse.de>
Date:   Tue May 22 22:47:54 2007 -0400

    PCI: make pci_bus a struct device

fixes the problem for him (this seems to be yet another reboot/poweroff IOW).

Thanks,
Rafael
