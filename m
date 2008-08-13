Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbYHMHEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbYHMHEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbYHMHDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:03:55 -0400
Received: from PSYCHOSIS.MIT.EDU ([18.95.2.5]:59515 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbYHMHDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:03:54 -0400
X-Greylist: delayed 609 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Aug 2008 03:03:54 EDT
Date: Wed, 13 Aug 2008 02:53:35 -0400
From: Jim Paris <jim@jtan.com>
To: ibm-acpi-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: rfkill vs. HAL, 2.6.27-rc3
Message-ID: <20080813065335.GA7359@psychosis.jim.sh>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On my Thinkpad X61, I have lots of problems on 2.6.26.1 when toggling
rfkill switches and buttons, including kernel crashes, so I'm trying
out 2.6.27-rc3.  Rfkill seems much better behaved, but Network-manager
is not very happy with it and no longer notices when the radio is
killed.

I think this is because it uses the HAL killswitch interface
  org.freedesktop.Hal.Device.KillSwitch
which calls the script
  hal-system-killswitch-get-power
which calls
  hal-system-killswitch-get-power-linux
which uses the binary
  hal-ipw-killswitch-linux
to check
  /sys/class/net/wlan0/device/rf_kill.

But this file no longer exists.  It seems to have been renamed to 
"/sys/class/net/wlan0/device/rfkill:rfkill2", which is extra annoying
because it's not just a rename, now hal-ipw-killswitch-linux will have
to find the "rfkill2" suffix.

Seems like a kernel regression if upgrading breaks user applications.
Or does this sound like a HAL bug?  Or Network-manager?  Or..?

(tracking a single bit of state is getting way too complex these
days...)

-jim
