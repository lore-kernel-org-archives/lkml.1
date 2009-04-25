Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZDYNVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZDYNVt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 09:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbZDYNVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 09:21:40 -0400
Received: from mpv2.tis.cwru.edu ([129.22.105.37]:16533 "EHLO
	mpv2.tis.cwru.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZDYNVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 09:21:39 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Sat, 25 Apr 2009 09:21:39 EDT
From: CSights <csights@fastmail.fm>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: resume from suspend fails using video card i915 / v2.6.29
Date: Sat, 25 Apr 2009 09:15:33 -0400
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904250915.33775.csights@fastmail.fm>
X-Junkmail-Status: score=35/49, host=mpv2.tis.cwru.edu
X-Junkmail-SD-Raw: score=suspect(0),
	refid=str=0001.0A090201.49F30CF9.0051,ss=2,fgs=0,
	ip=70.236.69.227,
	so=2009-03-06 19:59:02,
	dmn=5.4.3/2007-10-18,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
   After updating to 2.6.29 I was no longer able to resume from a suspend to
disk in KDE 4.2.2.  The kernel is read from disk, but then when entering
graphical mode all I get is a mouse cursor on a black screen.  Moving the
cursor works, but nothing else I tried had an effect. (I remember trying
touch-pad clicking, CTRL-ALT-F1, CTRL-ALT-BACKSPACE).
   I did a git bisect and found the first bad commit to be:
---------------------------
ac048e1734699dd98f4bdf4daf2b9592d4a4d38e is first bad commit
commit .
Author: Dave Airlie <airlied@redhat.com>
Date:   Tue Feb 3 19:05:12 2009 +1000

    i915: fix unneeded locking in i915 LVDS get modes code.

    This code is always called under the lock from the higher layers,
    so need to go locking it here.

    Signed-off-by: Dave Airlie <airlied@redhat.com>

:040000 040000 e3deb382edd0019bcd9cb4cc3e06ecd95e0ca502
9edc0fa234f4e8a2c3ffa6c3435f392fc1a488ed M      drivers
---------------------------
   I reverted this commit by hand for kernel v2.6.29. The computer once again
successfully resumes.
   The "current" (as of yesterday evening) kernel also shows these symptoms. 
Version 2.6.30-rc2-00446-ga939b96 fails to resume unless the above commit is
reverted.
   Possibly the "lock from higher levels" referred to in the commit was
removed?

Let me know if/what more info is needed,
   C.

$ lspci                                                          
00:00.0 Host bridge: Intel Corporation Mobile 915GM/PM/GMS/910GML Express
Processor to DRAM Controller (rev 03)                                           
00:02.0 VGA compatible controller: Intel Corporation Mobile 915GM/GMS/910GML
Express Graphics Controller (rev 03)                                            
00:02.1 Display controller: Intel Corporation Mobile 915GM/GMS/910GML Express
Graphics Controller (rev 03)
00:1b.0 Audio device: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
High Definition Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI
Express Port 1 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family) PCI
Express Port 4 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
USB UHCI #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
USB UHCI #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
USB UHCI #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
USB UHCI #4 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
USB2 EHCI Controller (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev d3)
00:1f.0 ISA bridge: Intel Corporation 82801FBM (ICH6M) LPC Interface Bridge
(rev 03)
00:1f.1 IDE interface: Intel Corporation 82801FB/FBM/FR/FW/FRW (ICH6 Family)
IDE Controller (rev 03)
02:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX (rev
02)
02:03.0 Network controller: Intel Corporation PRO/Wireless 2915ABG [Calexico2]
Network Connection (rev 05)
