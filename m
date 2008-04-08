Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbYDHUTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbYDHUTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbYDHUTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:19:30 -0400
Received: from outbound-mail-141.bluehost.com ([67.222.38.31]:38262 "HELO
	outbound-mail-141.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752042AbYDHUT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:19:29 -0400
To: dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: DRM modesetting & sysfs
Content-Disposition: inline
From: Jesse Barnes <jbarnes@virtuousgeek.org>
Date: Tue, 8 Apr 2008 13:17:43 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200804081317.43712.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry for the DUP, forgot to cc lkml]

I just pushed a few changes updating the DRM modesetting sysfs support, both 
for debugging and eventual HAL friendliness.

So far, the support is limited to describing outputs and generating hotplug 
events.  A typical "card0" directory now looks like this:

.
|-- card0-DAC-1
|   |-- device -> ../../../../../../devices/pci0000:00/0000:00:02.0/drm/card0
|   |-- dpms
|   |-- edid
|   |-- modes
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- subsystem -> ../../../../../../class/drm
|   `-- uevent
|-- card0-LVDS-1
|   |-- device -> ../../../../../../devices/pci0000:00/0000:00:02.0/drm/card0
|   |-- dpms
|   |-- edid
|   |-- modes
|   |-- power
|   |   `-- wakeup
|   |-- status
|   |-- subsystem -> ../../../../../../class/drm
|   `-- uevent
|-- dev
|-- device -> ../../../../../devices/pci0000:00/0000:00:02.0
|-- dri_library_name
|-- power
|   `-- wakeup
|-- subsystem -> ../../../../../class/drm
`-- uevent

Each output is listed, prefixed with its associated card number to 
disambiguate it at the top level /sys/class/drm directory (where it also has 
some symlinks).  Currently, only DPMS, EDID, mode list and connection status 
properties are exported, but we could list more as needed.  You can 
use 'udevmonitor --env' to look for hotplug events; you should see several at 
load time, and presumably some at connection hotplug time (though I haven't 
gotten that working yet, any ideas Jakob?).

Any thoughts on the interface?  Anything in particular people would like to 
see?

Thanks,
Jesse
