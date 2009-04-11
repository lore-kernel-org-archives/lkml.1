Return-Path: <linux-kernel-owner+w=401wt.eu-S1757059AbZDKJlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757059AbZDKJlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 05:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZDKJll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 05:41:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:64212 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZDKJlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 05:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=OiFOe2jmaCqGL3NMfl0MuBpTHd2akVII4+dcBEkQSPtxAevId+VoE3T63EN6+tCeap
         TCvJlsiueyNy+TWYPjB4sSpKEO9HC75A2k7SAq4nW/xbhBYNMgDZc5R/TgEkUIiAqNij
         TnOr0+8YSbrtcoPWAHErQwFwNy+xVCyUfACJs=
Message-ID: <49E065CF.6040408@tuffmail.co.uk>
Date: Sat, 11 Apr 2009 10:41:35 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-acpi@vger.kernel.org
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Regression: EEE PC hangs when booting off battery
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regression #6 on latest git! (last known good is 2.6.29-rc8)

My EEE PC hangs on bootup if it is not connected to mains power.  The
hang happens during udev coldplug.  I've left it for >60 seconds with
nmi_watchdog=1, soft lockup and hung task detection are enabled, and I
get no trace.  Key presses are not echoed to the screen.

Magic SysRQ keys work though.  Unfortunately, SysRq-W / SysRq-T generate
too much output, so the useful bits immediately scroll off the top of
the screen.  I can't press SysRq-P (even if that would help), because
the SysRQ key on my laptop is accessed using a Fn modifier key, which
also turns the left hand side of the keyboard into a numeric pad.

Magic SysRQs on my USB keyboard generate no response.  (Sometimes the
numlock key seems to work though.  I can't tell on the laptop keyboard
because the laptop doesn't have a numlock led).

I also tried booting with vga=ask (anticipating nmi_watchdog output),
and selecting the highest mode, 80x60.  It turns out that this doesn't
really work, the screen flickers constantly until userspace changes the
console font.  However, it avoided the hang in udev coldplug.  Instead,
the hang occurred when X started, leaving me with a black screen and a
non-responsive X cursor.

Booting with acpi=off fixes this.

Regards
Alan
