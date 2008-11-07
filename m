Return-Path: <linux-kernel-owner+w=401wt.eu-S1754012AbYKGMaK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbYKGMaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 07:30:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbYKGM34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 07:29:56 -0500
Received: from smooth.piipiip.net ([194.100.76.170]:50422 "EHLO
	smooth.piipiip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbYKGM34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 07:29:56 -0500
X-Greylist: delayed 2756 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 07:29:56 EST
Date: Fri, 7 Nov 2008 13:43:55 +0200
From: Jarkko Lavinen <jlavi@iki.fi>
To: linux-kernel@vger.kernel.org
Subject: i82875p_edac: BAR 0 collision
Message-ID: <20081107114355.GA31730@piipiip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux smooth.piipiip.net 2.6.18-5-k7
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: jlavi@piipiip.net
X-SA-Exim-Scanned: No (on smooth.piipiip.net); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I try to load i82875p_edac module on ASUS P4C800 Deluxe in 2.6.26
or 2.6.27 it fails due to BAR 0 collision. On 2.6.25 the
i82875p_edac works just fine.

Should i82875p_setup_overfl_dev() do some additional work to fix the
missing resource of the hidden overflow device?

When I try load i82875p_edac module on 2.6.27 I get

  # modprobe i82875p_edac
  FATAL: Error inserting i82875p_edac
  (/lib/modules/2.6.27.4/kernel/drivers/edac/i82875p_edac.ko): No such device

And dmesg shows (from 2.6.27.4):

  EDAC MC: Ver: 2.1.0 Oct 30 2008
  EDAC DEBUG: edac_pci_dev_parity_clear()
  ...
  EDAC DEBUG: edac_pci_dev_parity_clear()
  EDAC DEBUG: edac_sysfs_setup_mc_kset()
  EDAC DEBUG: edac_sysfs_setup_mc_kset() Registered '.../edac/mc' kobject
  EDAC DEBUG: i82875p_init_one()
  EDAC i82875p: i82875p init one
  EDAC DEBUG: i82875p_probe1()
  PCI: 0000:00:06.0 reg 10 32bit mmio: [fecf0000, fecf0fff]
  pci 0000:00:06.0: device not available because of BAR 0 [0xfecf0000-0xfecf0fff] collisions
  EDAC i82875p: i82875p_setup_overfl_dev(): Failed to enable overflow device
  EDAC DEBUG: 875p init fail

On 2.6.25.19 loading i82875p_edac works just fine and dmesg shows:

  EDAC MC: Ver: 2.1.0 Nov  4 2008
  EDAC i82875p: i82875p init one
  EDAC MC0: Giving out device to 'i82875p_edac' 'i82875p': DEV 0000:00:00.0
  EDAC PCI0: Giving out device to module 'i82875p_edac' controller 'EDAC PCI controller': DEV '0000:00:00.0' (POLLED)

Cheers
Jarkko Lavinen
