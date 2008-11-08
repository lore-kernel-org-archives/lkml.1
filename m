Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYKHXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYKHXiS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 18:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYKHXiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 18:38:01 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41672 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYKHXiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 18:38:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Smolik <marvin@mydatex.cz>
Subject: Re: [Bugme-new] [Bug 11886] New: without serial console system doesn't poweroff
Date: Sun, 9 Nov 2008 00:42:32 +0100
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
References: <bug-11886-10286@http.bugzilla.kernel.org/> <200811040148.34707.rjw@sisk.pl> <490FEC1B.5070105@mydatex.cz>
In-Reply-To: <490FEC1B.5070105@mydatex.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811090042.33219.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 4 of November 2008, Daniel Smolik wrote:
> Rafael J. Wysocki napsal(a):
> > On Monday, 3 of November 2008, Daniel Smolik wrote:
> >> Andrew Morton napsal(a):
> >>> (switched to email.  Please respond via emailed reply-to-all, not via the
> >>> bugzilla web interface).
> >>>
> >>> On Wed, 29 Oct 2008 04:06:11 -0700 (PDT)
> >>> bugme-daemon@bugzilla.kernel.org wrote:
> >>>
> >>>> http://bugzilla.kernel.org/show_bug.cgi?id=11886
> >>>>
> >>>>            Summary: without serial console system doesn't  poweroff
> >>>>            Product: Power Management
> >>>>            Version: 2.5
> >>>>      KernelVersion: 2.6.27.4
> >>>>           Platform: All
> >>>>         OS/Version: Linux
> >>>>               Tree: Mainline
> >>>>             Status: NEW
> >>>>           Severity: normal
> >>>>           Priority: P1
> >>>>          Component: Other
> >>>>         AssignedTo: power-management_other@kernel-bugs.osdl.org
> >>>>         ReportedBy: marvin@mydatex.cz
> >>>>
> >>>>
> >>>> Latest working kernel version:
> >>>> Earliest failing kernel version:2.6.27.2
> >>>> Distribution: Debian Etch
> >>>> Hardware Environment: Supermiro C2SBC-Q  Dual Core Intel Cpu 1G RAM
> >>>> Software Environment: Debian Etch
> >>>> Problem Description: If I does't add serial console to kernel command line
> >>>> system doesn't poweroff. Linux hangs there:
> >>>>
> >>>> e1000e 0000:0d:00.0: PCI INT A disabled
> >>>> e1000e 0000:00:19.0: PCI INT A disabled
> >>>> ACPI: Preparing to enter system sleep state S5
> >>>> Disabling non-boot CPUs ...
> >>>>
> >>>> If I disable in kernel config Suspend to Ram and Hibernate all works without
> >>>> console. But with Suspend and hibernate enabled and serial console  added to
> >>>> kernel cmd line all works too:
> >>>>
> >>>> e1000e 0000:0d:00.0: PCI INT A disabled
> >>>> e1000e 0000:00:19.0: PCI INT A disabled
> >>>> ACPI: Preparing to enter system sleep state S5
> >>>> Disabling non-boot CPUs ...
> >>>> CPU 1 is now offline
> >>>> SMP alternatives: switching to UP code
> >>>> CPU1 is down
> >>>> Power down.
> >>>> acpi_power_off called
> >>>>
> >>>> Steps to reproduce:
> >>>> Compile kernel with attached config and try poweroff without serial console.
> >>>>
> >>> OK, this is weird.
> >>>
> >>> But the good news is that there is a very small number of commits
> >>> between 2.6.27.2 and 2.6.27.4.
> >>>
> >>> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.3
> >>> ftp://ftp.kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.27.4
> >>>
> >>> I'd be looking at these:
> >>>
> >>> commit 3b987ac961486373f91191b14291b331fa546072
> >>> Author: Rafael J. Wysocki <rjw@sisk.pl>
> >>> Date:   Sat Sep 6 13:13:01 2008 +0200
> >>>
> >>>     ACPI suspend: Always use the 32-bit waking vector
> >>>     
> >>>     commit a6629105dd03d370fcb31e97bddf223fa4bb651e upstream.
> >>>
> >>>
> >>> commit 66036f5862883fcc9f7ff8550685a5a3de1a57e4
> >>> Author: Rafael J. Wysocki <rjw@sisk.pl>
> >>> Date:   Sat Oct 4 00:05:05 2008 +0200
> >>>
> >>>     ACPI Suspend: Enable ACPI during resume if SCI_EN is not set
> >>>     
> >>>     commit d0c71fe7ebc180f1b7bc7da1d39a07fc19eec768 upstream.
> >>>
> >>>
> >>>
> >>> presumably 2.6.28-rc3 is also broken?
> >> I don't know I can test it on Thu. But may be may fault or misunderstanding fist kernel which I test is 2.27.2. I don't 
> >> test any kernel before. I don't know if 2.6.26 works.
> > 
> > Can you try 2.6.26, please?
> Yes, no problem.

And did it work?

Rafael
