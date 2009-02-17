Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZBQOfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZBQOfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 09:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbZBQOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 09:35:09 -0500
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:55842 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbZBQOfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 09:35:08 -0500
X-Greylist: delayed 2169 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 09:35:08 EST
Date: Tue, 17 Feb 2009 13:58:57 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: corentincj@iksaif.net, acpi4asus-user@lists.sourceforge.net,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: EeePC card reader activated after suspend to ram
Message-ID: <20090217135857.GA2854@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found that there is a particular circumstance when the card reader
in my EeePC 900 will always be activated on resume even though before
the suspend to ram it was switched off.

The steps to reproduce are as follows:

1. Ensure the card reader is enabled before Linux boots (e.g. if Linux
is already running do (as root)
echo 1 > /sys/devices/platform/eeepc/cardr
and then reboot).
2. In the freshly booted kernel issue (as root)
echo 0 > /sys/devices/platform/eeepc/cardr
3. Initiate suspend to RAM e.g.:
echo mem > /sys/power/state 
4. Press a key to resume.

Notice that the logs will contain something similar to the following:

kernel: [  841.435629] Restarting tasks ... done.
kernel: [  907.576216] usb 1-5: new high speed USB device using ehci_hcd and address 3
kernel: [  907.699381] usb 1-5: configuration #1 chosen from 1 choice
kernel: [  907.707460] scsi3 : SCSI emulation for USB Mass Storage devices

Doing
cat /sys/devices/platform/eeepc/cardr
returns 0. Issuing
echo 0 > /sys/devices/platform/eeepc/cardr
even though the card reader is supposedly off will result in it being
disabled until after the next suspend to ram/resume.

Reproduced with a clean 2.6.29rc5 and the heavily Xandros patched
Xandros 2.6.21 kernel that the Eee ships with.

Does anyone have any ideas about this one?

-- 
Sitsofe | http://sucs.org/~sits/
