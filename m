Return-Path: <linux-kernel-owner+w=401wt.eu-S1754788AbYKEHdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788AbYKEHdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 02:33:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYKEHdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 02:33:11 -0500
Received: from eazy.amigager.de ([213.239.192.238]:37511 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYKEHdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 02:33:10 -0500
Date: Wed, 5 Nov 2008 08:33:08 +0100
From: Tino Keitel <tino.keitel@tikei.de>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081105073306.GA3132@x61>
Mail-Followup-To: ibm-acpi-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I tried 2.6.28-rc3 (git a75952b) on my ThinkPad X61s, and now the fan
runs at full speed after resume from suspend:

$ cat /proc/acpi/ibm/fan
status:		enabled
speed:		0
level:		auto
commands:	level <level> (<level> is 0-7, auto, disengaged,
full-speed)
commands:	enable, disable
commands:	watchdog <timeout> (<timeout> is 0 (off), 1-120
(seconds))
$ echo mem > /sys/power/state

After resume:

$ cat /proc/acpi/ibm/fan
status:		enabled
speed:		4796
level:		7
commands:	level <level> (<level> is 0-7, auto, disengaged,
full-speed)
commands:	enable, disable
commands:	watchdog <timeout> (<timeout> is 0 (off), 1-120
(seconds))

Setting it back again to "auto" works. After the next suspend cycle, it
is back to level 7.

This doesn't happen with 2.6.27.

Regards,
Tino
