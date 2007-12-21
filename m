Return-Path: <linux-kernel-owner+w=401wt.eu-S1756544AbXLUWrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544AbXLUWrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXLUWrB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:47:01 -0500
Received: from ironport1.lbl.gov ([128.3.41.47]:7671 "EHLO ironport1.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbXLUWrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:47:00 -0500
X-Greylist: delayed 618 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Dec 2007 17:47:00 EST
X-Ironport-SBRS: 3.5
X-Brightmail-Tracker: AAAAAA==
X-BrightmailFiltered: true
X-IronPort-AV: E=Sophos;i="4.24,196,1196668800"; 
   d="scan'208";a="77502299"
Date: Fri, 21 Dec 2007 14:36:38 -0800 (PST)
From: Andrei Gaponenko <andrei.gaponenko@cern.ch>
X-X-Sender: andr@0-11-d8-ea-8d-5b.dhcp.lbl.gov
To: linux-kernel@vger.kernel.org
cc: rui.zhang@intel.com, corentincj@iksaif.net, sziwan@users.sourceforge.net
Subject: video breaks asus-laptop display switching
Message-ID: <Pine.LNX.4.64.0712211433030.3239@0-11-d8-ea-8d-5b.dhcp.lbl.gov>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

With 2.6.23 or newer (including 2.6.24-rc6) kernels, writing to the
/sys/devices/platform/asus-laptop/display file does not do anything:

Cold boot to single user, then connect an external monitor

# cat  /sys/devices/platform/asus-laptop/display
1

OK, only the built in LCD is enabled. Try to enable
the external monitor as well:

# echo 3 > /sys/devices/platform/asus-laptop/display

still no image on the external.

# cat  /sys/devices/platform/asus-laptop/display
1

Still "1", not the "3" we wrote. On the other hand if I boot with an
external monitor attached, the "display" file always contains 3, even
after writing 1 there, and there is image on both monitors.

In 2.6.22 I had to load asus-laptop by hand, but then display
switching worked nicely.  

I've noticed that if I do 

# rmmod video

display switching starts working again with the newer kernels.
The "video" module was auto-loaded on my system in 2.6.22, but
did not cause the conflict.

This is an ASUS Z71V based notebook (detected as M7V).

Regards,
Andrei

