Return-Path: <linux-kernel-owner+w=401wt.eu-S965131AbXBQKFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965131AbXBQKFy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965127AbXBQKFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:05:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44632 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965124AbXBQKFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:05:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-ide@vger.kernel.org
Subject: 2.6.20-git10 (and -git13): BUG at drivers/pci/pci.c:817 during resume from disk
Date: Sat, 17 Feb 2007 11:00:38 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@osdl.org>, Jeff Garzik <jeff@garzik.org>,
       Alan <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>
References: <200702150016.24865.rjw@sisk.pl> <200702151223.44846.rjw@sisk.pl>
In-Reply-To: <200702151223.44846.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702171100.39114.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Update:

I get the same BUG with 2.6.20-git13 100% of the time during the resume.
The system seems to be fully functional nonetheless.

On Thursday, 15 February 2007 12:23, Rafael J. Wysocki wrote:
> Update:
> 
> On Thursday, 15 February 2007 00:16, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > I've got this in the resume-during-suspend phase of suspend to disk with
> > 2.6.20-git10 on HPC nx6325:
> > 
> > PCI: Setting latency timer of device 0000:00:06.0 to 64
> > sata_sil 0000:00:12.0: resuming
> > BUG: at drivers/pci/pci.c:817 pcim_enable_device()
> > 
> > Call Trace:
> >  [<ffffffff8031c05e>] pcim_enable_device+0x93/0xb3
> >  [<ffffffff8039a74c>] ata_pci_device_do_resume+0x21/0x5e
> >  [<ffffffff803a5f8a>] sil_pci_device_resume+0x1c/0x51
> >  [<ffffffff8031e072>] pci_device_resume+0x22/0x53
> >  [<ffffffff8038bea4>] resume_device+0xca/0x131
> >  [<ffffffff8038bf8c>] dpm_resume+0x81/0xd3
> >  [<ffffffff8038c00e>] device_resume+0x30/0x45
> >  [<ffffffff802a0d8c>] snapshot_ioctl+0x245/0x63e
> >  [<ffffffff8023f7f2>] do_ioctl+0x5e/0x77
> >  [<ffffffff8022dab2>] vfs_ioctl+0x25c/0x279
> >  [<ffffffff8024948a>] sys_ioctl+0x5f/0x82
> >  [<ffffffff8021555d>] sys_write+0x47/0x70
> >  [<ffffffff8025911e>] system_call+0x7e/0x83
> > 
> > The box has survived the entire suspend-resume cycle, though, and seems to be
> > fully functional.
> 
> I get this 100% of the time, but the box suspends and behaves normally after
> the resume.
